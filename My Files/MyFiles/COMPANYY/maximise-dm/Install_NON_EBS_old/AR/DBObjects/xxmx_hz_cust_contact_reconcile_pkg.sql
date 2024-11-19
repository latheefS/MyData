create or replace PACKAGE xxmx_hz_cust_contact_reconcile_pkg AUTHID CURRENT_USER
     --
     /*
     ******************************************************************************
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
     ******************************************************************************
     **
     **
     ** FILENAME  :  xxmx_hz_cust_contact_reconcile_pkg.sql
     **
     ** FILEPATH  :  $XXV1_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  David Higham
     **
     ** PURPOSE   :  This script installs the package specification for the Maximise
     **              package xxmx_hz_cust_contact_reconcile_pkg custom Procedure.
     **
     ** NOTES     :
     **
     *******************************************************************************
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
     ** xxcust_common_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  20-AUG-2021  David Higham        Initial implementation
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
    AS
     --
     /*
     ******************************
     ** PROCEDURE: populate_table
     ******************************
     */
     --

    PROCEDURE populate_table
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                        );
         --
    END xxmx_hz_cust_contact_reconcile_pkg;
/

create or replace PACKAGE BODY xxmx_hz_cust_contact_reconcile_pkg
    AS
     /*
     **********************
     ** Global Declarations
     **********************
     */
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     --
	 --ASharma
	 gc_orig_system VARCHAR2(10) :='CSV';
	 --ASharma

     gcv_PackageName                           CONSTANT VARCHAR2(30)                                 := 'xxmx_hz_cust_contact_reconcile';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AR';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gcv_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'CUSTOMERS-RECON';
     gcv_MaskingEmail                          CONSTANT VARCHAR2(30)                                 := 'oracletesters@solihull.gov.uk';
     --
     /* Global Progress Indicator Variable for use in all Procedures/Functions within this package */
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     /* Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     /* Global constants and variables for dynamic SQL usage */
     --
     gcv_SQLSpace                             CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                                      VARCHAR2(20);
     gvv_SQLTableClause                                 VARCHAR2(100);
     gvv_SQLColumnList                                  VARCHAR2(4000);
     gvv_SQLValuesList                                  VARCHAR2(4000);
     gvv_SQLWhereClause                                 VARCHAR2(4000);
     gvv_SQLStatement                                   VARCHAR2(32000);
     gvv_SQLResult                                      VARCHAR2(4000);
     --
     /* Global variables for holding table row counts */
     --
     gvn_RowCount                                       NUMBER;
     --
         PROCEDURE populate_table
                        (
                         pt_i_MigrationSetID   IN      xxmx_migration_headers.migration_set_id%TYPE 
                        )
        IS
        BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => gcv_BusinessEntity 
               ,pt_i_Phase               => 'CORE'
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => 'populate_table'
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||'xxmx_hz_cust_contact_reconcile'
                                            ||'.'
                                            ||'populate_table'
                                            ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );        


          DELETE FROM  xxmx_hz_cust_contact_reconcile where migration_set_id = pt_i_MigrationSetID;

-- ----------------------------------------------------------
-- Insert EBS SHIPTO
-- ----------------------------------------------------------
         INSERT INTO  xxmx_hz_cust_contact_reconcile 
         (
          MIGRATION_SET_ID 
         ,DATA_SOURCE      
         ,DATA_TYPE        
         ,ACCOUNT_NUMBER   
         ,ACCOUNT_NAME     
         ,ACCOUNT_SITE     
         ,CONTACT_NAME     
         ,ADDRESS1         
         ,ADDRESS2         
         ,CITY             
         ,POSTAL_CODE      
         ,EMAIL_ADDRESS    
         ,EMAIL_FORMAT     
         ,PHONE_NUMBER 
         )
         SELECT distinct 
                pt_i_MigrationSetID,
                'EBS',
                'SHIPTO',
                BillToCus.account_number                  bill2_account_number,
                BillToCus.account_name                    bill2_account_name,
                BillToSite.cust_account_id||'-'||BillToSite.cust_acct_site_id account_site,
                nvl(ShipToPty.person_first_name,ShipToPty.party_name)||' '||nvl(ShipToPty.person_last_name,'ShipTo Contact') ship2_account_name,                
                ShipToSiteLoc.address1                    address1,
                ShipToSiteLoc.address2                    address2,
                ShipToSiteLoc.city                        city,
                ShipToSiteLoc.postal_code                 postal_code,
                '','',''
         FROM   (select distinct cust_account_id, account_number, account_party_id party_id, cust_acct_site_id, org_id
                         from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,apps.hz_locations@MXDM_NVIS_EXTRACT               ShipToSiteLoc                  
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             ShipToPtySite
               ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      ShipToUses
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     ShipToSite
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 ShipToPty
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           ShipToCus
               ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT   BillToPtyUsg
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 BillToPty                  
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     BillToSite
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           BillToCus
         WHERE   1=1
         AND    BillToCus.cust_account_id     = selection.cust_account_id
         AND    BillToCus.account_number      = selection.account_number
         AND    BillToCus.attribute1 is not null
         AND    BillToSite.cust_account_id    = selection.cust_account_id
         AND    BillToSite.cust_acct_site_id  = selection.cust_acct_site_id
         AND    BillToSite.org_id             = selection.org_id		 
         AND    BillToPty.party_id            = BillToCus.party_id
         AND    BillToPty.status              = 'A'
         AND    BillToPtyUsg.party_id         = BillToCus.party_id
         AND    BillToPtyUsg.status_flag      = 'A'
         AND    BillToPtyUsg.party_usage_code = 'CUSTOMER'
         AND    upper(ShipToCus.attribute2)   = upper(BillToCus.attribute1)
         AND    ShipToSite.cust_account_id    = ShipToCus.cust_account_id
         AND    ShipToSite.status             = 'A'
         AND    ShipToPty.party_id            = ShipToCus.party_id
         AND    ShipToPty.status              = 'A'
         AND    ShipToPtySite.party_site_id = ShipToSite.party_site_id
         AND    ShipToSiteLoc.location_id = ShipToPtySite.location_id
         AND    ShipToUses.cust_acct_site_id = ShipToSite.cust_acct_site_id
         AND    ShipToUses.org_id            = ShipToSite.org_id
         AND    ShipToUses.site_use_code = 'SHIP_TO'
         AND    ShipToUses.primary_flag = 'Y'
         AND    ShipToUses.status = 'A';

commit;
-- ----------------------------------------------------------
-- Insert STG SHIPTO
-- ----------------------------------------------------------
         INSERT INTO  xxmx_hz_cust_contact_reconcile 
         (
          MIGRATION_SET_ID 
         ,DATA_SOURCE      
         ,DATA_TYPE        
         ,ACCOUNT_NUMBER   
         ,ACCOUNT_NAME     
         ,ACCOUNT_SITE     
         ,CONTACT_NAME     
         ,ADDRESS1         
         ,ADDRESS2         
         ,CITY             
         ,POSTAL_CODE      
         ,EMAIL_ADDRESS    
         ,EMAIL_FORMAT     
         ,PHONE_NUMBER 
         )
         SELECT /*+ RULE */
                 distinct 
                pt_i_MigrationSetID,
                'STG',
                'SHIPTO',                
                hca.account_number, 
                hca.account_name, 
                hcac.cust_site_orig_sys_ref account_site,
                hps2.person_first_name||' '||hps2.person_last_name contact_name,
                hls2.address1,
                hls2.address2,
                hls2.city,
                hls2.postal_code,
                '','',''
from   
        xxmx_hz_locations_stg hls2,
        xxmx_hz_party_sites_stg hpss2,
        xxmx_hz_parties_stg hps2,
        xxmx_hz_relationships_stg r,
        xxmx_hz_cust_acct_sites_stg hcas,
        xxmx_hz_cust_accounts_stg hca,       
        xxmx_hz_cust_acct_contacts_stg hcac
where  hcac.migration_set_id = pt_i_MigrationSetID
and    hcac.rel_orig_system_reference like 'XXB2%'
and    hca.migration_set_id = hcac.migration_set_id
and    hca.cust_orig_system_reference = hcac.cust_orig_system_reference
and    hcas.migration_set_id = hcac.migration_set_id
and    hcas.cust_site_orig_sys_ref = hcac.cust_site_orig_sys_ref
and    r.migration_set_id = hcac.migration_set_id
and    r.rel_orig_system_reference = hcac.rel_orig_system_reference
and    hps2.migration_set_id = r.migration_set_id
and    hps2.party_orig_system_reference = r.sub_orig_system_reference
and    hpss2.migration_set_id = hps2.migration_set_id
and    hpss2.party_orig_system_reference = hps2.party_orig_system_reference
and    hls2.migration_set_id = hpss2.migration_set_id
and    hls2.location_orig_system_reference = hpss2.location_orig_system_reference;

commit;

-- ----------------------------------------------------------
-- Insert EBS EBILLING
-- ----------------------------------------------------------

         INSERT INTO  xxmx_hz_cust_contact_reconcile 
         (
          MIGRATION_SET_ID 
         ,DATA_SOURCE      
         ,DATA_TYPE        
         ,ACCOUNT_NUMBER   
         ,ACCOUNT_NAME     
         ,ACCOUNT_SITE     
         ,CONTACT_NAME     
         ,ADDRESS1         
         ,ADDRESS2         
         ,CITY             
         ,POSTAL_CODE      
         ,EMAIL_ADDRESS    
         ,EMAIL_FORMAT     
         ,PHONE_NUMBER 
         ) 
        SELECT DISTINCT
                pt_i_MigrationSetID,
                'EBS',
                'EBILLING',
                hca.account_number,
                hca.account_name,
                hcas.cust_account_id||'-'||hcas.cust_acct_site_id,
                'eBilling Contact' contact_name,
                '' address1,
                '' address2,
                '' city,
                '' postal_code,
                nvl(hcp.email_address, 'sundryincometeam@solihull.gov.uk') email_address,
                nvl(hcp.email_format, 'MAILTEXT') email_format,
                '' phone_number
        FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
               ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
        WHERE  1 = 1
        AND    hcp.owner_table_id(+)       = selection.party_site_id
        AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
        AND    hcp.status(+)               = 'A'
        AND    hcp.primary_flag(+)         = 'Y'
        AND    hcp.contact_point_type(+)   = 'EMAIL'
        AND    hps.party_Site_Id           = selection.party_site_id
        AND    hpp.party_id                = hps.party_id
        AND    hca.cust_account_id         = selection.cust_account_id
        AND    hca.account_number          = selection.account_number
        AND    hcas.cust_account_id        = hca.cust_account_id
        AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
        AND    hcas.party_site_id          = selection.party_site_id
        AND    hcas.org_id                 = selection.org_id;

commit;
-- ----------------------------------------------------------
-- Insert STG EBILLING
-- ----------------------------------------------------------

         INSERT INTO  xxmx_hz_cust_contact_reconcile 
         (
          MIGRATION_SET_ID 
         ,DATA_SOURCE      
         ,DATA_TYPE        
         ,ACCOUNT_NUMBER   
         ,ACCOUNT_NAME     
         ,ACCOUNT_SITE     
         ,CONTACT_NAME     
         ,ADDRESS1         
         ,ADDRESS2         
         ,CITY             
         ,POSTAL_CODE      
         ,EMAIL_ADDRESS    
         ,EMAIL_FORMAT     
         ,PHONE_NUMBER 
         )
         SELECT /*+ RULE */ DISTINCT
                pt_i_MigrationSetID migration_set_id,
                'STG'  data_source,
                'EBILLING' data_type,                
                hca.account_number account_number, 
                hca.account_name account_name, 
                hcac.cust_site_orig_sys_ref account_site,
                hps2.person_first_name||' '||hps2.person_last_name contact_name,
                '' address1,
                '' address2,
                '' city,
                '' postal_code,
                hcp.email_address email_address,
                hcp.email_format email_format,
               '' phone_number
         FROM   
                 xxmx_hz_contact_points_stg hcp,
                 xxmx_hz_parties_stg hps2,
                 xxmx_hz_relationships_stg r,
                 xxmx_hz_cust_acct_sites_stg hcas,
                 xxmx_hz_cust_accounts_stg hca,       
                 xxmx_hz_cust_acct_contacts_stg hcac
         WHERE  hcac.migration_set_id = pt_i_MigrationSetID
         AND    hcac.rel_orig_system_reference like 'XXDM-EB%'
         AND    hca.migration_set_id = hcac.migration_set_id
         AND    hca.cust_orig_system_reference = hcac.cust_orig_system_reference
         AND    hcas.migration_set_id = hcac.migration_set_id
         AND    hcas.cust_site_orig_sys_ref = hcac.cust_site_orig_sys_ref
         AND    r.migration_set_id = hcac.migration_set_id
         AND    r.rel_orig_system_reference = hcac.rel_orig_system_reference
         AND    hps2.migration_set_id = r.migration_set_id
         AND    hps2.party_orig_system_reference = r.sub_orig_system_reference
         AND    hcp.migration_set_id = r.migration_set_id
         AND    hcp.rel_orig_system_reference = r.rel_orig_system_reference
         AND    hcp.party_orig_system_reference = r.sub_orig_system_reference;

commit;

-- ----------------------------------------------------------
-- Insert EBS COLLECTIONS
-- ----------------------------------------------------------

         INSERT INTO  xxmx_hz_cust_contact_reconcile 
         (
          MIGRATION_SET_ID 
         ,DATA_SOURCE      
         ,DATA_TYPE        
         ,ACCOUNT_NUMBER   
         ,ACCOUNT_NAME     
         ,ACCOUNT_SITE     
         ,CONTACT_NAME     
         ,ADDRESS1         
         ,ADDRESS2         
         ,CITY             
         ,POSTAL_CODE      
         ,EMAIL_ADDRESS    
         ,EMAIL_FORMAT     
         ,PHONE_NUMBER 
         ) 
         SELECT  DISTINCT
                pt_i_MigrationSetID migration_set_id,
                'EBS'  data_source,
                'COLLECTIONS' data_type,
                hca.account_number account_number,
                hca.account_name   account_name,
                hcas.cust_account_id||'-'||hcas.cust_acct_site_id account_site,
                'Collections Contact' contact_name,
                '' address1,
                '' address2,
                '' city,
                '' postal_code,
                '' email_address,
                '' email_format,
                decode(hcp.phone_area_code,'','',hcp.phone_area_code||' ')||hcp.phone_number phone_number
         FROM   (select distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      = 'PHONE'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101'
         UNION
         SELECT  DISTINCT
                pt_i_MigrationSetID migration_set_id,
                'EBS'  data_source,
                'COLLECTIONS' data_type,
                hca.account_number account_number,
                hca.account_name   account_name,
                hcas.cust_account_id||'-'||hcas.cust_acct_site_id account_site,
                'Collections Contact' contact_name,
                '' address1,
                '' address2,
                '' city,
                '' postal_code,
                hcp.email_address email_address,
                hcp.email_format  email_format,
                '' phone_number
         FROM   (select distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101';

commit;

-- ----------------------------------------------------------
-- Insert STG COLLECTIONS
-- ----------------------------------------------------------
         INSERT INTO  xxmx_hz_cust_contact_reconcile 
         SELECT /*+ RULE */ DISTINCT
                pt_i_MigrationSetID migration_set_id,
                'STG'  data_source,
                'COLLECTIONS' data_type,                
                hca.account_number account_number, 
                hca.account_name account_name, 
                hcac.cust_site_orig_sys_ref account_site,
                hps2.person_first_name||' '||hps2.person_last_name contact_name,
                '' address1,
                '' address2,
                '' city,
                '' postal_code,
                hcp.email_address email_address,
                hcp.email_format email_format,
                decode(hcp.phone_area_code,'','',hcp.phone_area_code||' ')||hcp.phone_number phone_number              
         FROM   
                 xxmx_hz_contact_points_stg hcp,
                 xxmx_hz_parties_stg hps2,
                 xxmx_hz_relationships_stg r,
                 xxmx_hz_cust_acct_sites_stg hcas,
                 xxmx_hz_cust_accounts_stg hca,       
                 xxmx_hz_cust_acct_contacts_stg hcac
         WHERE  hcac.migration_set_id = pt_i_MigrationSetID
         AND    hcac.rel_orig_system_reference like 'XXDM-CC%'
         AND    hca.migration_set_id = hcac.migration_set_id
         AND    hca.cust_orig_system_reference = hcac.cust_orig_system_reference
         AND    hcas.migration_set_id = hcac.migration_set_id
         AND    hcas.cust_site_orig_sys_ref = hcac.cust_site_orig_sys_ref
         AND    r.migration_set_id = hcac.migration_set_id
         AND    r.rel_orig_system_reference = hcac.rel_orig_system_reference
         AND    hps2.migration_set_id = r.migration_set_id
         AND    hps2.party_orig_system_reference = r.sub_orig_system_reference
         AND    hcp.migration_set_id = r.migration_set_id
         AND    hcp.rel_orig_system_reference = r.rel_orig_system_reference
         AND    hcp.party_orig_system_reference = r.sub_orig_system_reference;

commit;


update  xxmx_hz_cust_contact_reconcile
set    email_address = 'oracletesters@solihull.gov.uk'
where  email_address is not null
and    migration_set_id = pt_i_MigrationSetID;

commit;

          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => gcv_BusinessEntity 
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => 'CORE'
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => 'populate_table'
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||'xxmx_hz_cust_contact_reconcile'
                                            ||'.'
                                            ||'populate_table'
                                            ||'" completed.'
               ,pt_i_OracleError         => NULL
               );
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
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity => gcv_BusinessEntity
                         ,pt_i_Phase               => 'CORE'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => 'populate_table'
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
     END populate_table;          
END xxmx_hz_cust_contact_reconcile_pkg;
/