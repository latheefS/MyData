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
--** FILENAME  :  xxmx_ar_trx_stg_dbi.sql
--**
--** FILEPATH  :  $XXMX_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script installs the XXMX_STG schema database objects for
--**              the Maximise AR Transactions Data Migration.
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
--** 1.    
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
--** xxcust_xxmx_ra_invoices_stg_dbi.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  09-JUL-2020  Ian S. Vickerstaff  Created from original V1 Solutions
--**                                         Limited version.
--**
--**   1.1  17-NOV-2020  David Fuller        Add LEDGER_NAME to xxmx_ar_trx_dists_stg
--**
--**   1.2  12-MAY-2021  Ian S. Vickerstaff  Added XXMX_CUSTOMER_TRX_ID,
--**                                         XXMX_CUSTOMER_TRX_LINE_ID and
--**                                         XXMX_LINE_NUMBER columns to the
--**                                         XXMX_AR_TRX_LINES_STG table.
--**
--**                                         Added XXMX_CUSTOMER_TRX_ID, 
--**                                         XXMX_CUSTOMER_TRX_LINE_ID and
--**                                         XXMX_CUST_TRX_LINE_GL_DIST_ID columns
--**                                         to the XXMX_AR_TRX_DISTS_STG table.
--**
--**                                         Added XXMX_CUSTOMER_TRX_ID and 
--**                                         XXMX_CUSTOMER_TRX_LINE_ID columns
--**                                         to the XXMX_AR_TRX_SALESCREDITS_STG
--**                                         table.
--**
--**   1.2  16-JUN-2021  Ian S. Vickerstaff  Added XXMX_CUST_TRX_LINE_SALESREP_ID
--**                                         column to the XXMX_AR_TRX_SALESCREDITS_STG
--**                                         table.
--**
--**   1.3  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
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
--**  NUMBER or INTEGER (if its purpose was to store an Oracle internal ID)
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
--**          the package itself) or defined in the package specification
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
--
--

--
--
PROMPT
PROMPT
PROMPT *************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise AR Invoices Data Migration
PROMPT **
PROMPT *************************************************************
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
PROMPT Dropping Tables 
PROMPT
--
EXEC DropTable ('XXMX_AR_TRX_LINES_STG')
EXEC DropTable ('XXMX_AR_TRX_DISTS_STG')
EXEC DropTable ('XXMX_AR_TRX_SALESCREDITS_STG')
--
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
/*
** TABLE : xxmx_ar_trx_lines_stg
--Migration_set_id is generated in the maximise Code
--File_set_id is mandatory for Data File (non-Ebs Source)

*/
--
CREATE TABLE xxmx_ar_trx_lines_stg 
     (
      file_set_id                     VARCHAR2(30)
     ,migration_set_id                 NUMBER
     ,migration_set_name               VARCHAR2(150)
     ,migration_status                 VARCHAR2(50)
     ,row_seq                          NUMBER
     ,xxmx_customer_trx_id             NUMBER
     ,xxmx_customer_trx_line_id        NUMBER
     ,xxmx_line_number                 NUMBER
     ,operating_unit                   VARCHAR2(240)
     ,ORG_ID			       NUMBER
     ,fusion_business_unit             VARCHAR2(240)
     ,batch_source_name                VARCHAR2(50)
     ,cust_trx_type_name               VARCHAR2(20)
     ,term_name                        VARCHAR2(15)
     ,trx_date                         DATE
     ,gl_date                          DATE
     ,trx_number                       VARCHAR2(20)
     ,orig_system_bill_customer_ref    VARCHAR2(240)
     ,orig_system_bill_address_ref     VARCHAR2(240)
     ,orig_system_bill_contact_ref     VARCHAR2(240)
     ,orig_sys_ship_party_ref          VARCHAR2(240)
     ,orig_sys_ship_party_site_ref     VARCHAR2(240)
     ,orig_sys_ship_pty_contact_ref    VARCHAR2(240)
     ,orig_system_ship_customer_ref    VARCHAR2(240)
     ,orig_system_ship_address_ref     VARCHAR2(240)
     ,orig_system_ship_contact_ref     VARCHAR2(240)
     ,orig_sys_sold_party_ref          VARCHAR2(240)
     ,orig_sys_sold_customer_ref       VARCHAR2(240)
     ,bill_customer_account_number     VARCHAR2(240)
     ,bill_customer_site_number        VARCHAR2(240)
     ,bill_contact_party_number        VARCHAR2(240)
     ,ship_customer_account_number     VARCHAR2(240)
     ,ship_customer_site_number        VARCHAR2(240)
     ,ship_contact_party_number        VARCHAR2(240)
     ,sold_customer_account_number     VARCHAR2(240)
     ,line_type                        VARCHAR2(20)
     ,description                      VARCHAR2(240)
     ,currency_code                    VARCHAR2(15)
     ,conversion_type                  VARCHAR2(30)
     ,conversion_date                  DATE
     ,conversion_rate                  NUMBER
     ,trx_line_amount                  NUMBER
     ,quantity                         NUMBER
     ,quantity_ordered                 NUMBER
     ,unit_selling_price               NUMBER
     ,unit_standard_price              NUMBER
     ,interface_line_context           VARCHAR2(30)
     ,interface_line_attribute1        VARCHAR2(30)
     ,interface_line_attribute2        VARCHAR2(30)
     ,interface_line_attribute3        VARCHAR2(30)
     ,interface_line_attribute4        VARCHAR2(30)
     ,interface_line_attribute5        VARCHAR2(30)
     ,interface_line_attribute6        VARCHAR2(30)
     ,interface_line_attribute7        VARCHAR2(30)
     ,interface_line_attribute8        VARCHAR2(30)
     ,interface_line_attribute9        VARCHAR2(30)
     ,interface_line_attribute10       VARCHAR2(30)
     ,interface_line_attribute11       VARCHAR2(30)
     ,interface_line_attribute12       VARCHAR2(30)
     ,interface_line_attribute13       VARCHAR2(30)
     ,interface_line_attribute14       VARCHAR2(30)
     ,interface_line_attribute15       VARCHAR2(30)
     ,primary_salesrep_number          VARCHAR2(30)
     ,tax_classification_code          VARCHAR2(50)
     ,legal_entity_identifier          VARCHAR2(30)
     ,acct_amount_in_ledger_currency   NUMBER
     ,sales_order_number               VARCHAR2(50)
     ,sales_order_date                 DATE
     ,actual_ship_date                 DATE
     ,warehouse_code                   VARCHAR2(18)
     ,unit_of_measure_code             VARCHAR2(3)
     ,unit_of_measure_name             VARCHAR2(25)
     ,invoicing_rule_name              VARCHAR2(30)
     ,revenue_scheduling_rule_name     VARCHAR2(30)
     ,number_of_revenue_periods        VARCHAR2(18)
     ,rev_scheduling_rule_start_date   DATE
     ,rev_scheduling_rule_end_date     DATE
     ,reason_code_meaning              VARCHAR2(80)
     ,last_period_to_credit            NUMBER
     ,trx_business_category_code       VARCHAR2(240)
     ,product_fiscal_class_code        VARCHAR2(240)
     ,product_category_code            VARCHAR2(240)
     ,product_type                     VARCHAR2(240)
     ,line_intended_use_code           VARCHAR2(240)
     ,assessable_value                 NUMBER
     ,document_sub_type                VARCHAR2(240)
     ,default_taxation_country         VARCHAR2(2)
     ,user_defined_fiscal_class        VARCHAR2(30)
     ,tax_invoice_number               VARCHAR2(150)
     ,tax_invoice_date                 DATE
     ,tax_regime_code                  VARCHAR2(30)
     ,tax                              VARCHAR2(30)
     ,tax_status_code                  VARCHAR2(30)
     ,tax_rate_code                    VARCHAR2(30)
     ,tax_jurisdiction_code            VARCHAR2(30)
     ,first_party_reg_number           VARCHAR2(60)
     ,third_party_reg_number           VARCHAR2(30)
     ,final_discharge_location         VARCHAR2(60)
     ,taxable_amount                   NUMBER
     ,taxable_flag                     VARCHAR2(1)
     ,tax_exempt_flag                  VARCHAR2(1)
     ,tax_exempt_reason_code           VARCHAR2(30)
     ,tax_exempt_reason_code_meaning   VARCHAR2(80)
     ,tax_exempt_certificate_number    VARCHAR2(80)
     ,line_amount_includes_tax_flag    VARCHAR2(1)
     ,tax_precedence                   NUMBER
     ,credit_method_for_acct_rule      VARCHAR2(30)
     ,credit_method_for_installments   VARCHAR2(30)
     ,reason_code                      VARCHAR2(30)
     ,tax_rate                         NUMBER
     ,fob_point                        VARCHAR2(30)
     ,ship_via                         VARCHAR2(25)
     ,waybill_number                   VARCHAR2(50)
     ,sales_order_line_number          VARCHAR2(30)
     ,sales_order_source               VARCHAR2(50)
     ,sales_order_revision_number      NUMBER
     ,purchase_order_number            VARCHAR2(50)
     ,purchase_order_revision_number   VARCHAR2(50)
     ,purchase_order_date              DATE
     ,agreement_name                   VARCHAR2(30)
     ,memo_line_name                   VARCHAR2(50)
     ,document_number                  NUMBER
     ,orig_system_batch_name           VARCHAR2(40)
     ,link_to_line_context             VARCHAR2(30)
     ,link_to_line_attribute1          VARCHAR2(30)
     ,link_to_line_attribute2          VARCHAR2(30)
     ,link_to_line_attribute3          VARCHAR2(30)
     ,link_to_line_attribute4          VARCHAR2(30)
     ,link_to_line_attribute5          VARCHAR2(30)
     ,link_to_line_attribute6          VARCHAR2(30)
     ,link_to_line_attribute7          VARCHAR2(30)
     ,link_to_line_attribute8          VARCHAR2(30)
     ,link_to_line_attribute9          VARCHAR2(30)
     ,link_to_line_attribute10         VARCHAR2(30)
     ,link_to_line_attribute11         VARCHAR2(30)
     ,link_to_line_attribute12         VARCHAR2(30)
     ,link_to_line_attribute13         VARCHAR2(30)
     ,link_to_line_attribute14         VARCHAR2(30)
     ,link_to_line_attribute15         VARCHAR2(30)
     ,reference_line_context           VARCHAR2(30)
     ,reference_line_attribute1        VARCHAR2(30)
     ,reference_line_attribute2        VARCHAR2(30)
     ,reference_line_attribute3        VARCHAR2(30)
     ,reference_line_attribute4        VARCHAR2(30)
     ,reference_line_attribute5        VARCHAR2(30)
     ,reference_line_attribute6        VARCHAR2(30)
     ,reference_line_attribute7        VARCHAR2(30)
     ,reference_line_attribute8        VARCHAR2(30)
     ,reference_line_attribute9        VARCHAR2(30)
     ,reference_line_attribute10       VARCHAR2(30)
     ,reference_line_attribute11       VARCHAR2(30)
     ,reference_line_attribute12       VARCHAR2(30)
     ,reference_line_attribute13       VARCHAR2(30)
     ,reference_line_attribute14       VARCHAR2(30)
     ,reference_line_attribute15       VARCHAR2(30)
     ,link_to_parentline_context       VARCHAR2(240)
     ,link_to_parentline_attribute1    VARCHAR2(30)
     ,link_to_parentline_attribute2    VARCHAR2(30)
     ,link_to_parentline_attribute3    VARCHAR2(30)
     ,link_to_parentline_attribute4    VARCHAR2(30)
     ,link_to_parentline_attribute5    VARCHAR2(30)
     ,link_to_parentline_attribute6    VARCHAR2(30)
     ,link_to_parentline_attribute7    VARCHAR2(30)
     ,link_to_parentline_attribute8    VARCHAR2(30)
     ,link_to_parentline_attribute9    VARCHAR2(30)
     ,link_to_parentline_attribute10   VARCHAR2(30)
     ,link_to_parentline_attribute11   VARCHAR2(30)
     ,link_to_parentline_attribute12   VARCHAR2(30)
     ,link_to_parentline_attribute13   VARCHAR2(30)
     ,link_to_parentline_attribute14   VARCHAR2(30)
     ,link_to_parentline_attribute15   VARCHAR2(30)
     ,receipt_method_name              VARCHAR2(30)
     ,printing_option                  VARCHAR2(20)
     ,related_batch_source_name        VARCHAR2(50)
     ,related_transaction_number       VARCHAR2(20)
     ,inventory_item_number            VARCHAR2(40)
     ,inventory_item_segment2          VARCHAR2(40)
     ,inventory_item_segment3          VARCHAR2(40)
     ,inventory_item_segment4          VARCHAR2(40)
     ,inventory_item_segment5          VARCHAR2(40)
     ,inventory_item_segment6          VARCHAR2(40)
     ,inventory_item_segment7          VARCHAR2(40)
     ,inventory_item_segment8          VARCHAR2(40)
     ,inventory_item_segment9          VARCHAR2(40)
     ,inventory_item_segment10         VARCHAR2(40)
     ,inventory_item_segment11         VARCHAR2(40)
     ,inventory_item_segment12         VARCHAR2(40)
     ,inventory_item_segment13         VARCHAR2(40)
     ,inventory_item_segment14         VARCHAR2(40)
     ,inventory_item_segment15         VARCHAR2(40)
     ,inventory_item_segment16         VARCHAR2(40)
     ,inventory_item_segment17         VARCHAR2(40)
     ,inventory_item_segment18         VARCHAR2(40)
     ,inventory_item_segment19         VARCHAR2(40)
     ,inventory_item_segment20         VARCHAR2(40)
     ,bill_to_cust_bank_acct_name      VARCHAR2(80)
     ,reset_trx_date_flag              VARCHAR2(1)
     ,payment_server_order_number      VARCHAR2(80)
     ,last_trans_on_debit_auth         VARCHAR2(1)
     ,approval_code                    VARCHAR2(80)
     ,address_verification_code        VARCHAR2(80)
     ,translated_description           VARCHAR2(1000)
     ,consolidated_billing_number      VARCHAR2(30)
     ,promised_commitment_amount       NUMBER
     ,payment_set_identifier           NUMBER
     ,original_gl_date                 DATE
     ,invoiced_line_accting_level      VARCHAR2(15)
     ,override_auto_accounting_flag    VARCHAR2(1)
     ,historical_flag                  VARCHAR2(1)
     ,deferral_exclusion_flag          VARCHAR2(1)
     ,payment_attributes               VARCHAR2(1000)
     ,invoice_billing_date             DATE
     ,attribute_category               VARCHAR2(30)
     ,attribute1                       VARCHAR2(150)
     ,attribute2                       VARCHAR2(150)
     ,attribute3                       VARCHAR2(150)
     ,attribute4                       VARCHAR2(150)
     ,attribute5                       VARCHAR2(150)
     ,attribute6                       VARCHAR2(150)
     ,attribute7                       VARCHAR2(150)
     ,attribute8                       VARCHAR2(150)
     ,attribute9                       VARCHAR2(150)
     ,attribute10                      VARCHAR2(150)
     ,attribute11                      VARCHAR2(150)
     ,attribute12                      VARCHAR2(150)
     ,attribute13                      VARCHAR2(150)
     ,attribute14                      VARCHAR2(150)
     ,attribute15                      VARCHAR2(150)
     ,header_attribute_category        VARCHAR2(30)
     ,header_attribute1                VARCHAR2(150)
     ,header_attribute2                VARCHAR2(150)
     ,header_attribute3                VARCHAR2(150)
     ,header_attribute4                VARCHAR2(150)
     ,header_attribute5                VARCHAR2(150)
     ,header_attribute6                VARCHAR2(150)
     ,header_attribute7                VARCHAR2(150)
     ,header_attribute8                VARCHAR2(150)
     ,header_attribute9                VARCHAR2(150)
     ,header_attribute10               VARCHAR2(150)
     ,header_attribute11               VARCHAR2(150)
     ,header_attribute12               VARCHAR2(150)
     ,header_attribute13               VARCHAR2(150)
     ,header_attribute14               VARCHAR2(150)
     ,header_attribute15               VARCHAR2(150)
     ,header_gdf_attr_category         VARCHAR2(30)
     ,header_gdf_attribute1            VARCHAR2(150)
     ,header_gdf_attribute2            VARCHAR2(150)
     ,header_gdf_attribute3            VARCHAR2(150)
     ,header_gdf_attribute4            VARCHAR2(150)
     ,header_gdf_attribute5            VARCHAR2(150)
     ,header_gdf_attribute6            VARCHAR2(150)
     ,header_gdf_attribute7            VARCHAR2(150)
     ,header_gdf_attribute8            VARCHAR2(150)
     ,header_gdf_attribute9            VARCHAR2(150)
     ,header_gdf_attribute10           VARCHAR2(150)
     ,header_gdf_attribute11           VARCHAR2(150)
     ,header_gdf_attribute12           VARCHAR2(150)
     ,header_gdf_attribute13           VARCHAR2(150)
     ,header_gdf_attribute14           VARCHAR2(150)
     ,header_gdf_attribute15           VARCHAR2(150)
     ,header_gdf_attribute16           VARCHAR2(150)
     ,header_gdf_attribute17           VARCHAR2(150)
     ,header_gdf_attribute18           VARCHAR2(150)
     ,header_gdf_attribute19           VARCHAR2(150)
     ,header_gdf_attribute20           VARCHAR2(150)
     ,header_gdf_attribute21           VARCHAR2(150)
     ,header_gdf_attribute22           VARCHAR2(150)
     ,header_gdf_attribute23           VARCHAR2(150)
     ,header_gdf_attribute24           VARCHAR2(150)
     ,header_gdf_attribute25           VARCHAR2(150)
     ,header_gdf_attribute26           VARCHAR2(150)
     ,header_gdf_attribute27           VARCHAR2(150)
     ,header_gdf_attribute28           VARCHAR2(150)
     ,header_gdf_attribute29           VARCHAR2(150)
     ,header_gdf_attribute30           VARCHAR2(150)
     ,line_gdf_attr_category           VARCHAR2(30)
     ,line_gdf_attribute1              VARCHAR2(150)
     ,line_gdf_attribute2              VARCHAR2(150)
     ,line_gdf_attribute3              VARCHAR2(150)
     ,line_gdf_attribute4              VARCHAR2(150)
     ,line_gdf_attribute5              VARCHAR2(150)
     ,line_gdf_attribute6              VARCHAR2(150)
     ,line_gdf_attribute7              VARCHAR2(150)
     ,line_gdf_attribute8              VARCHAR2(150)
     ,line_gdf_attribute9              VARCHAR2(150)
     ,line_gdf_attribute10             VARCHAR2(150)
     ,line_gdf_attribute11             VARCHAR2(150)
     ,line_gdf_attribute12             VARCHAR2(150)
     ,line_gdf_attribute13             VARCHAR2(150)
     ,line_gdf_attribute14             VARCHAR2(150)
     ,line_gdf_attribute15             VARCHAR2(150)
     ,line_gdf_attribute16             VARCHAR2(150)
     ,line_gdf_attribute17             VARCHAR2(150)
     ,line_gdf_attribute18             VARCHAR2(150)
     ,line_gdf_attribute19             VARCHAR2(150)
     ,line_gdf_attribute20             VARCHAR2(150)
     ,comments                         VARCHAR2(240)
     ,internal_notes                   VARCHAR2(240)
     ,CC_TOKEN_NUMBER		       VARCHAR2(30)
     ,CC_EXPIRATION_DATE 	       DATE
     ,CC_FIRST_NAME		       VARCHAR2(40)
     ,CC_LAST_NAME		       VARCHAR2(40)
     ,CC_ISSUER_CODE		       VARCHAR2(30)
     ,CC_MASKED_NUMBER	       	       VARCHAR2(30)
     ,CC_AUTH_REQUEST_ID	       VARCHAR2(30)
     ,CC_VOICE_AUTH_CODE	       VARCHAR2(100)
     ,header_gdf_attribute_number1     NUMBER
     ,header_gdf_attribute_number2     NUMBER
     ,header_gdf_attribute_number3     NUMBER
     ,header_gdf_attribute_number4     NUMBER
     ,header_gdf_attribute_number5     NUMBER
     ,header_gdf_attribute_number6     NUMBER
     ,header_gdf_attribute_number7     NUMBER
     ,header_gdf_attribute_number8     NUMBER
     ,header_gdf_attribute_number9     NUMBER
     ,header_gdf_attribute_number10    NUMBER
     ,header_gdf_attribute_number11    NUMBER
     ,header_gdf_attribute_number12    NUMBER
     ,header_gdf_attribute_date1       DATE
     ,header_gdf_attribute_date2       DATE
     ,header_gdf_attribute_date3       DATE
     ,header_gdf_attribute_date4       DATE
     ,header_gdf_attribute_date5       DATE
     ,line_gdf_attribute_number1       NUMBER
     ,line_gdf_attribute_number2       NUMBER
     ,line_gdf_attribute_number3       NUMBER
     ,line_gdf_attribute_number4       NUMBER
     ,line_gdf_attribute_number5       NUMBER
     ,line_gdf_attribute_date1         DATE
     ,line_gdf_attribute_date2         DATE
     ,line_gdf_attribute_date3         DATE
     ,line_gdf_attribute_date4         DATE
     ,line_gdf_attribute_date5         DATE
     ,freight_charge                   NUMBER
     ,insurance_charge                 NUMBER
     ,packing_charge                   NUMBER
     ,miscellaneous_charge             NUMBER
     ,commercial_discount              NUMBER
     ,ENF_SEQ_DATE_CORRELATION_CODE	VARCHAR2(1)
     ,PAYMENT_TRXN_EXTENSION_ID		NUMBER
     ,INTERFACE_STATUS 			VARCHAR2(1)
     ,ATTRIBUTE_NUMBER1			NUMBER
     ,ATTRIBUTE_NUMBER2			NUMBER
     ,ATTRIBUTE_NUMBER3			NUMBER
     ,ATTRIBUTE_NUMBER4			NUMBER
     ,ATTRIBUTE_NUMBER5			NUMBER
     ,ATTRIBUTE_DATE1			DATE
     ,ATTRIBUTE_DATE2			DATE
     ,ATTRIBUTE_DATE3			DATE
     ,ATTRIBUTE_DATE4			DATE
     ,ATTRIBUTE_DATE5			DATE
     ,HEADER_ATTRIBUTE_NUMBER1		NUMBER
     ,HEADER_ATTRIBUTE_NUMBER2		NUMBER
     ,HEADER_ATTRIBUTE_NUMBER3		NUMBER
     ,HEADER_ATTRIBUTE_NUMBER4		NUMBER
     ,HEADER_ATTRIBUTE_NUMBER5		NUMBER
     ,HEADER_ATTRIBUTE_DATE1		DATE
     ,HEADER_ATTRIBUTE_DATE2		DATE
     ,HEADER_ATTRIBUTE_DATE3		DATE
     ,HEADER_ATTRIBUTE_DATE4		DATE
     ,HEADER_ATTRIBUTE_DATE5		DATE
     ,LOAD_BATCH 			VARCHAR2(300)
     );
--
/*
** TABLE : xxmx_ar_trx_dists_stg
*/
--
CREATE TABLE xxmx_ar_trx_dists_stg 
     (
      file_set_id                     VARCHAR2(30)	 
     ,migration_set_id                NUMBER
     ,migration_set_name              VARCHAR2(150) 
     ,migration_status                VARCHAR2(50) 
     ,row_seq                         NUMBER
     ,xxmx_customer_trx_id            NUMBER
     ,xxmx_customer_trx_line_id       NUMBER
     ,xxmx_cust_trx_line_gl_dist_id   NUMBER
     ,operating_unit                  VARCHAR2(240) 
     ,ORG_ID			       NUMBER
     ,ledger_name                     VARCHAR2(30)
     ,account_class                   VARCHAR2(20) 
     ,amount                          NUMBER 
     ,percent                         NUMBER
     ,accounted_amt_in_ledger_curr    NUMBER 
     ,interface_line_context          VARCHAR2(30) 
     ,interface_line_attribute1       VARCHAR2(30) 
     ,interface_line_attribute2       VARCHAR2(30) 
     ,interface_line_attribute3       VARCHAR2(30) 
     ,interface_line_attribute4       VARCHAR2(30) 
     ,interface_line_attribute5       VARCHAR2(30) 
     ,interface_line_attribute6       VARCHAR2(30) 
     ,interface_line_attribute7       VARCHAR2(30) 
     ,interface_line_attribute8       VARCHAR2(30) 
     ,interface_line_attribute9       VARCHAR2(30) 
     ,interface_line_attribute10      VARCHAR2(30) 
     ,interface_line_attribute11      VARCHAR2(30) 
     ,interface_line_attribute12      VARCHAR2(30) 
     ,interface_line_attribute13      VARCHAR2(30) 
     ,interface_line_attribute14      VARCHAR2(30) 
     ,interface_line_attribute15      VARCHAR2(30) 
     ,segment1                        VARCHAR2(25) 
     ,segment2                        VARCHAR2(25) 
     ,segment3                        VARCHAR2(25) 
     ,segment4                        VARCHAR2(25) 
     ,segment5                        VARCHAR2(25) 
     ,segment6                        VARCHAR2(25) 
     ,segment7                        VARCHAR2(25) 
     ,segment8                        VARCHAR2(25) 
     ,segment9                        VARCHAR2(25) 
     ,segment10                       VARCHAR2(25) 
     ,segment11                       VARCHAR2(25) 
     ,segment12                       VARCHAR2(25) 
     ,segment13                       VARCHAR2(25) 
     ,segment14                       VARCHAR2(25) 
     ,segment15                       VARCHAR2(25) 
     ,segment16                       VARCHAR2(25) 
     ,segment17                       VARCHAR2(25) 
     ,segment18                       VARCHAR2(25) 
     ,segment19                       VARCHAR2(25) 
     ,segment20                       VARCHAR2(25) 
     ,segment21                       VARCHAR2(25) 
     ,segment22                       VARCHAR2(25) 
     ,segment23                       VARCHAR2(25) 
     ,segment24                       VARCHAR2(25) 
     ,segment25                       VARCHAR2(25) 
     ,segment26                       VARCHAR2(25) 
     ,segment27                       VARCHAR2(25) 
     ,segment28                       VARCHAR2(25) 
     ,segment29                       VARCHAR2(25) 
     ,segment30                       VARCHAR2(25) 
     ,comments                        VARCHAR2(240) 
     ,interim_tax_segment1            VARCHAR2(25) 
     ,interim_tax_segment2            VARCHAR2(25) 
     ,interim_tax_segment3            VARCHAR2(25) 
     ,interim_tax_segment4            VARCHAR2(25) 
     ,interim_tax_segment5            VARCHAR2(25) 
     ,interim_tax_segment6            VARCHAR2(25) 
     ,interim_tax_segment7            VARCHAR2(25) 
     ,interim_tax_segment8            VARCHAR2(25) 
     ,interim_tax_segment9            VARCHAR2(25) 
     ,interim_tax_segment10           VARCHAR2(25) 
     ,interim_tax_segment11           VARCHAR2(25) 
     ,interim_tax_segment12           VARCHAR2(25) 
     ,interim_tax_segment13           VARCHAR2(25) 
     ,interim_tax_segment14           VARCHAR2(25) 
     ,interim_tax_segment15           VARCHAR2(25) 
     ,interim_tax_segment16           VARCHAR2(25) 
     ,interim_tax_segment17           VARCHAR2(25) 
     ,interim_tax_segment18           VARCHAR2(25) 
     ,interim_tax_segment19           VARCHAR2(25) 
     ,interim_tax_segment20           VARCHAR2(25) 
     ,interim_tax_segment21           VARCHAR2(25) 
     ,interim_tax_segment22           VARCHAR2(25) 
     ,interim_tax_segment23           VARCHAR2(25) 
     ,interim_tax_segment24           VARCHAR2(25) 
     ,interim_tax_segment25           VARCHAR2(25) 
     ,interim_tax_segment26           VARCHAR2(25) 
     ,interim_tax_segment27           VARCHAR2(25) 
     ,interim_tax_segment28           VARCHAR2(25) 
     ,interim_tax_segment29           VARCHAR2(25) 
     ,interim_tax_segment30           VARCHAR2(25) 
     ,attribute_category              VARCHAR2(25) 
     ,attribute1                      VARCHAR2(150) 
     ,attribute2                      VARCHAR2(150) 
     ,attribute3                      VARCHAR2(150) 
     ,attribute4                      VARCHAR2(150) 
     ,attribute5                      VARCHAR2(150) 
     ,attribute6                      VARCHAR2(150) 
     ,attribute7                      VARCHAR2(150) 
     ,attribute8                      VARCHAR2(150) 
     ,attribute9                      VARCHAR2(150) 
     ,attribute10                     VARCHAR2(150) 
     ,attribute11                     VARCHAR2(150) 
     ,attribute12                     VARCHAR2(150) 
     ,attribute13                     VARCHAR2(150) 
     ,attribute14                     VARCHAR2(150) 
     ,attribute15                     VARCHAR2(150) 
     ,LOAD_BATCH VARCHAR2(300)
     );
--
/*
** TABLE : xxmx_ar_trx_salescredits_stg
*/
--
CREATE TABLE xxmx_ar_trx_salescredits_stg 
     (
	  file_set_id                     VARCHAR2(30)
     ,migration_set_id                NUMBER 
     ,migration_set_name              VARCHAR2(150)
     ,migration_status                VARCHAR2(50)
     ,row_seq                         NUMBER
     ,xxmx_cust_trx_line_salesrep_id  NUMBER
     ,xxmx_customer_trx_id            NUMBER
     ,xxmx_customer_trx_line_id       NUMBER
     ,operating_unit                  VARCHAR2(240)
     ,ORG_ID			       NUMBER
     ,salesrep_number                 VARCHAR2(30)
     ,sales_credit_type_name          VARCHAR2(30)
     ,sales_credit_amount_split       NUMBER
     ,sales_credit_percent_split      NUMBER
     ,interface_line_context          VARCHAR2(30)
     ,interface_line_attribute1       VARCHAR2(30)
     ,interface_line_attribute2       VARCHAR2(30)
     ,interface_line_attribute3       VARCHAR2(30)
     ,interface_line_attribute4       VARCHAR2(30)
     ,interface_line_attribute5       VARCHAR2(30)
     ,interface_line_attribute6       VARCHAR2(30)
     ,interface_line_attribute7       VARCHAR2(30)
     ,interface_line_attribute8       VARCHAR2(30)
     ,interface_line_attribute9       VARCHAR2(30)
     ,interface_line_attribute10      VARCHAR2(30)
     ,interface_line_attribute11      VARCHAR2(30)
     ,interface_line_attribute12      VARCHAR2(30)
     ,interface_line_attribute13      VARCHAR2(30)
     ,interface_line_attribute14      VARCHAR2(30)
     ,interface_line_attribute15      VARCHAR2(30)
     ,attribute_category              VARCHAR2(30)
     ,attribute1                      VARCHAR2(150)
     ,attribute2                      VARCHAR2(150)
     ,attribute3                      VARCHAR2(150)
     ,attribute4                      VARCHAR2(150)
     ,attribute5                      VARCHAR2(150)
     ,attribute6                      VARCHAR2(150)
     ,attribute7                      VARCHAR2(150)
     ,attribute8                      VARCHAR2(150)
     ,attribute9                      VARCHAR2(150)
     ,attribute10                     VARCHAR2(150)
     ,attribute11                     VARCHAR2(150)
     ,attribute12                     VARCHAR2(150)
     ,attribute13                     VARCHAR2(150)
     ,attribute14                     VARCHAR2(150)
     ,attribute15                     VARCHAR2(150)
     ,LOAD_BATCH VARCHAR2(300)
     );
--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting permissions
PROMPT ***********************
--
--
PROMPT
PROMPT Granting permissions on xxmx_ar_trx_lines_stg to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_ar_trx_lines_stg
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_ar_trx_dists_stg to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_ar_trx_dists_stg
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_ar_trx_salescredits_stg to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_ar_trx_salescredits_stg
          TO XXMX_CORE;
--
--
PROMPT
PROMPT
PROMPT **********************************
PROMPT **                                
PROMPT ** End of Database Object Creation
PROMPT **                                
PROMPT **********************************
PROMPT
