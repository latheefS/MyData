CREATE OR REPLACE package xxmx_gl_historical_rates_pkg as 
     --
     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2022 Version 1
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
     ** FILENAME  :  xxmx_gl_historical_rates_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  XXMX_CORE
     **
     ** AUTHORS   :  Shaik Latheef
     **
     ** PURPOSE   :  This script installs the package for the Maximise GL Historical Rates
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
     **            $XXMX_TOP/install/sql/xmxx_gl_historical_rates_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xmxx_gl_historical_rates_xfm_dbi.sql
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
     **   1.0  11-JUL-2023	Shaik Latheef       Created for Maximise
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

    /******************************************************************************	
	-----------------------------Export GL Historical Rates------------------------
	******************************************************************************/
    PROCEDURE stg_main 
        (
         pt_i_ClientCode                    IN          xxmx_client_config_parameters.client_code%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE );

    PROCEDURE gl_historical_rates_stg
       (
         pt_i_MigrationSetID             	IN      	xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  	IN      	xxmx_migration_metadata.sub_entity%TYPE );  


end xxmx_gl_historical_rates_pkg;
/


CREATE OR REPLACE PACKAGE BODY xxmx_gl_historical_rates_pkg
AS

-- ===========================================================================*/
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_gl_historicalrates_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                 CONSTANT  VARCHAR2(30)                                 := 'xxmx_gl_historical_rates_pkg';
     gct_ApplicationSuite            CONSTANT  xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                 CONSTANT  xxmx_module_messages.application%TYPE        := 'GL';
     gct_StgSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                  CONSTANT  VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity              CONSTANT  xxmx_migration_metadata.business_entity%TYPE := 'HISTORICAL_RATES';
     gct_SubEntity                   CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'HISTORICAL_RATES';
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
     --************************************
     --** PROCEDURE: gl_historicalrates_stg
     --************************************
     --

     PROCEDURE gl_historical_rates_stg
                    (
                       pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE,
                       pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the historical rates
          --
          CURSOR GLHistoricalrates_cur 
		              (
						pv_LedgerName VARCHAR2
                       ,pv_PeriodName VARCHAR2						
					  )
          IS
             --
             --
			        SELECT *
					FROM 
						(SELECT
								gl.name       ledger_name,
								'INSERT'      import_action,
								gcc.segment1  segment1,
								gcc.segment2  segment2,
								gcc.segment3  segment3,
								gcc.segment4  segment4,
								gcc.segment5  segment5,
								gcc.segment6  segment6,
                                gcc.segment7  segment7,
                                gcc.segment8  segment8,
                                gcc.segment9  segment9,
                                gcc.segment10  segment10,
                                gcc.segment11  segment11,
                                gcc.segment12  segment12,
                                gcc.segment13  segment13,
                                gcc.segment14  segment14,
                                gcc.segment15  segment15,
                                gcc.segment16  segment16,
                                gcc.segment17  segment17,
                                gcc.segment18  segment18,
                                gcc.segment19  segment19,
                                gcc.segment20  segment20,
                                gcc.segment21  segment21,
                                gcc.segment22  segment22,
                                gcc.segment23  segment23,
                                gcc.segment24  segment24,
                                gcc.segment25  segment25,
                                gcc.segment26  segment26,
                                gcc.segment27  segment27,
                                gcc.segment28  segment28,
                                gcc.segment29  segment29,
                                gcc.segment30  segment30,
								INITCAP(gp.period_name) period_name,
								glb.currency_code target_currency_code,
								'AMOUNT' value_type_code,
								 SUM(CASE WHEN glb.currency_code = gl.currency_code THEN
										(nvl(glb.begin_balance_dr_beq, 0) - nvl(glb.begin_balance_cr_beq, 0))
									   +(nvl(glb.period_net_dr_beq, 0) - nvl(glb.period_net_cr_beq, 0))
									 ELSE
										(nvl(glb.begin_balance_dr, 0) - nvl(glb.begin_balance_cr, 0)) 
									   +(nvl(glb.period_net_dr, 0) - nvl(glb.period_net_cr, 0))
									 END       
								)credit_amount_rate,
								(
								CASE /*WHEN gl.ret_earn_code_combination_id=gcc.code_combination_id THEN 
									  'YES'*/
									  WHEN (select gcc1.segment2 from apps.gl_code_combinations@MXDM_NVIS_EXTRACT gcc1 where gcc1.CODE_COMBINATION_ID= gl.ret_earn_code_combination_id)=gcc.segment2 THEN --added by Laxmikanth 
									  'YES'
									  ELSE 
									  'NO'
									  END
								)auto_roll_forward_flag       
							FROM
								apps.gl_ledgers@MXDM_NVIS_EXTRACT           gl,
								apps.gl_balances@MXDM_NVIS_EXTRACT          glb,
								apps.gl_code_combinations@MXDM_NVIS_EXTRACT gcc,
								apps.gl_periods@MXDM_NVIS_EXTRACT           gp
							WHERE
								1 = 1
								AND gl.name = pv_LedgerName
								AND gl.ledger_id = glb.ledger_id
								AND gcc.code_combination_id = glb.code_combination_id
								AND glb.period_name = gp.period_name
								AND gl.period_set_name=gp.period_set_name --added by Laxmikanth for duplicate fix
								AND gp.period_name = pv_PeriodName
								AND glb.actual_flag = 'A'
								AND nvl(glb.translated_flag, 'X') IN ( 'Y')
								AND glb.template_id IS NULL
								AND glb.currency_code != 'STAT'
							GROUP BY     
								gl.name,gcc.segment1,gcc.segment2,gcc.segment3,gcc.segment4,gcc.segment5,
								gcc.segment6,gcc.segment7,gcc.segment8,gcc.segment9,gcc.segment10,
                                gcc.segment11,gcc.segment12,gcc.segment13,gcc.segment14,gcc.segment15,
                                gcc.segment16,gcc.segment17,gcc.segment18,gcc.segment19,gcc.segment20,
                                gcc.segment21,gcc.segment22,gcc.segment23,gcc.segment24,gcc.segment25,
                                gcc.segment26,gcc.segment27,gcc.segment28,gcc.segment29,gcc.segment30,
								gp.period_name,glb.currency_code,gl.ret_earn_code_combination_id,
								gcc.code_combination_id
							)ghr
					WHERE 1=1
					AND credit_amount_rate != 0
					ORDER BY
						1,10,3,4,5,6,7,8;


          --

          --********************
          --** Type Declarations
          --********************
          --
          TYPE gl_historicalrates_tt IS TABLE OF GLHistoricalrates_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          /*
          ** This is declared in each Procedure within the package to allow for
          ** a different value to be assigned in the Staging/Transform/Export
          ** procedures.
          */
          --
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'gl_historical_rates_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_historical_rates_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE        := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ListParameterCode            xxmx_migration_parameters.parameter_code%TYPE;
          vn_ListValueCount               NUMBER;
          vb_OkayToExtract                BOOLEAN;
          vb_PeriodAndYearMatch           BOOLEAN;
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
          --
          --
          --****************************
          --** Record Table Declarations
          --****************************
          --
          --
          --
          --****************************
          --** PL/SQL Table Declarations
          --****************************
          --
          EmptyLedgerName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
		  LedgerName_tbl                  xxmx_utilities_pkg.g_ParamValueList_tt;
          EmptyPeriodName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          PeriodName_tbl                  xxmx_utilities_pkg.g_ParamValueList_tt;
          gl_historicalrates_tbl          gl_historicalrates_tt;
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
          --
     --** END Declarations
     --
     --
BEGIN
    --
    gvv_ProgressIndicator := '0010';
    --
    vb_OkayToExtract  := TRUE;
    gvv_ReturnStatus  := '';
    gvt_ReturnMessage := '';
	vt_MigrationSetID := pt_i_MigrationSetID;
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
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
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
               ,pt_i_MigrationSetID    => vt_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
    gvv_ProgressIndicator := '0040';
    --
    --** If the Migration Set ID is NULL then the Migration has not been initialized.
    --
    IF   vt_MigrationSetID IS NOT NULL THEN
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving ledger details from migration parameters table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
        gvv_ProgressIndicator := '0045';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
       /*
               ** The Migration Set has been initialized so not retrieve the
               ** Parameters for extracting GL Historical Rates:
               **
               ** 1) GL Ledger Name List
               ** 2) GL Period Name List
               */
               --
               /*
               ** Retrieve GL Ledger Names List
               */
               gvv_ProgressIndicator := '0046';
               --
               vt_ListParameterCode := 'LEDGER_NAME';
               vn_ListValueCount    := 0;
               gvv_ReturnStatus     := '';
               gvt_ReturnMessage    := '';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'
                                             ||vt_ListParameterCode
                                             ||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
               --
               LedgerName_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                      (
                                       pt_i_ApplicationSuite => gct_ApplicationSuite
                                      ,pt_i_Application      => gct_Application
                                      ,pt_i_BusinessEntity   => gct_BusinessEntity
                                      ,pt_i_SubEntity        => gct_SubEntity
                                      ,pt_i_ParameterCode    => vt_ListParameterCode
                                      ,pn_o_ReturnCount      => vn_ListValueCount
                                      ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                      ,pv_o_ReturnMessage    => gvt_ReturnMessage
                                      );
									  dbms_output.put_line(gct_ApplicationSuite||gct_Application||gct_BusinessEntity||gct_SubEntity||vt_ListParameterCode||vn_ListValueCount||gvv_ReturnStatus||gvt_ReturnMessage);
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
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Oracle error in called procedure "xxmx_utilities_pkg.get_parameter_value_list".  "'
                                                  ||vt_ListParameterCode
                                                  ||'" List could not be retrieved.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
                    --
                    RAISE e_ModuleError;
                    --
               ELSE
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - '
                                                  ||vn_ListValueCount
                                                  ||' values for "'
                                                  ||vt_ListParameterCode
                                                  ||'" List retrieved.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF;
               --
               IF   vn_ListValueCount = 0
               THEN
                    --
                    vb_OkayToExtract := FALSE;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - No "'
                                                  ||vt_ListParameterCode
                                                  ||'" parameters defined in "xxmx_migration_parameters" table.  GL Historical Rates can not be extracted at this time.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
                    --
               END IF;


        --
        --
        -- Retrieve GL Period Name List
        --
        --
        gvv_ProgressIndicator := '0060';
        --
        vt_ListParameterCode := 'PERIOD_NAME';
        vn_ListValueCount    := 0;
        gvv_ReturnStatus     := '';
        gvt_ReturnMessage    := '';
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'
                                             ||vt_ListParameterCode
                                             ||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
        --
        PeriodName_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                      (
                                       pt_i_ApplicationSuite => gct_ApplicationSuite
                                      ,pt_i_Application      => gct_Application
                                      ,pt_i_BusinessEntity   => gct_BusinessEntity
                                      ,pt_i_SubEntity        => 'HISTORICAL_RATES'
                                      ,pt_i_ParameterCode    => vt_ListParameterCode
                                      ,pn_o_ReturnCount      => vn_ListValueCount
                                      ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                      ,pv_o_ReturnMessage    => gvt_ReturnMessage
                                      );
        --
        IF   gvv_ReturnStatus = 'F' THEN
            --
            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Oracle error in called procedure "xxmx_utilities_pkg.get_parameter_value_list".  "'
                                                  ||vt_ListParameterCode
                                                  ||'" List could not be retrieved.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
                    --
            RAISE e_ModuleError;
            --
        ELSE
            --
            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - '
                                                  ||vn_ListValueCount
                                                  ||' values for "'
                                                  ||vt_ListParameterCode
                                                  ||'" List retrieved.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
        END IF;
        --
        IF   vn_ListValueCount = 0 THEN
            --
            vb_OkayToExtract := FALSE;
            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => gct_SubEntity
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'WARNING'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '    - No "'
                                                    ||vt_ListParameterCode
                                                    ||'" parameters defined in "xxmx_migration_parameters" table.  GL Historical Rates can not be extracted at this time.'
                         ,pt_i_OracleError         => gvt_ReturnMessage
                         );
                    --
        END IF;
        --
        --
        -- If there are no Extract Parameters in the "xxmx_migration_parameters" table
        -- (those which are there have to be enabled), no historical rates can be extracted.
        --
        --
        gvv_ProgressIndicator := '0070';
        --
        IF   vb_OkayToExtract THEN
            --
            --
            -- The Extract Parameters were successfully retrieved so now
            -- initialize the detail record for the GL historical rates.
            --
            xxmx_utilities_pkg.init_migration_details
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                         ,pt_i_OracleError       => NULL
                         );
            --
            --  loop through the Ledger Name list and for each one:
            --
            -- a) Retrieve COA Structure Details pertaining to the Ledger.
            -- b) Extract the historical rates for the Ledger.
            --
            gvv_ProgressIndicator := '0090';
            --
            FOR LedgerName_idx
            IN LedgerName_tbl.FIRST..LedgerName_tbl.LAST
            LOOP
                xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => gct_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Ledger name.'||LedgerName_tbl(LedgerName_idx)
                                 ,pt_i_OracleError       => NULL
                                 );
				/*--
                -- Loop through Extract Years List
                --
                FOR ExtractYear_idx
                IN ExtractYear_tbl.FIRST..ExtractYear_tbl.LAST
                LOOP
                    xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => vt_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Year.'
                                 ,pt_i_OracleError       => NULL
                                 );			 
                    --
                    --
                    -- The following variable will be set to TRUE if any of the Period Names
                    -- in the Period Name Parameters list exist for the current Extract Year
                    -- Parameter.  If no Period Name Parameters match to the current Extract
                    -- Year Parameter this variable will remain FALSE.
                    --
                    -- This is so an INFORMATION log message can be issued if there are no
                    -- Period Name Parameters which match to the current Extract Year Parameter.
                    --
                    vb_PeriodAndYearMatch := FALSE;*/
					
                    --
                    --
                    -- Loop through GL Period Names List
                    --
                    --
                    FOR PeriodName_idx
                    IN PeriodName_tbl.FIRST..PeriodName_tbl.LAST
                    LOOP
                        xxmx_utilities_pkg.log_module_message
                                     (
                                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                     ,pt_i_Application       => gct_Application
                                     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                     ,pt_i_SubEntity         => gct_SubEntity
                                     ,pt_i_MigrationSetID    => vt_MigrationSetID
                                     ,pt_i_Phase             => ct_Phase
                                     ,pt_i_Severity          => 'NOTIFICATION'
                                     ,pt_i_PackageName       => gcv_PackageName
                                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                     ,pt_i_ModuleMessage     => '    - Loop: Period Name '||PeriodName_tbl(PeriodName_idx)
                                     ,pt_i_OracleError       => NULL
                                     );
                        /*--
                        gvn_ExistenceCount := 0;
                        --
                        /*
                        ** Verify if the current Period Name Parameter exists
                        ** as a GL Period in the GL_PERIODS table for the current
                        ** Source Ledger Name and Extract Year Parameters.
                        */
                        --
                        /*gvv_ProgressIndicator := '0130';
                        --
                        --
                        -- Verify if the current Period Name Parameter exists in gl_ledgers and gl_periods tables
                        --
                        SELECT  COUNT(*)
                        INTO    gvn_ExistenceCount
                        FROM    apps.gl_ledgers@MXDM_NVIS_EXTRACT  gl2
                                ,apps.gl_periods@MXDM_NVIS_EXTRACT  gp
                        WHERE   1 = 1
                        AND     gl2.name           = LedgerName_tbl(LedgerName_idx)
                        AND     gp.period_set_name = gl2.period_set_name
                        AND     gp.period_year     = ExtractYear_tbl(ExtractYear_idx)
                        AND     gp.period_name     = PeriodName_tbl(PeriodName_idx);
                        --
                        IF   gvn_ExistenceCount = 0 THEN
                            xxmx_utilities_pkg.log_module_message
                                            (
                                             pt_i_ApplicationSuite  => gct_ApplicationSuite
                                            ,pt_i_Application       => gct_Application
                                            ,pt_i_BusinessEntity    => gct_BusinessEntity
                                            ,pt_i_SubEntity         => vt_SubEntity
                                            ,pt_i_MigrationSetID    => vt_MigrationSetID
                                            ,pt_i_Phase             => ct_Phase
                                            ,pt_i_Severity          => 'NOTIFICATION'
                                            ,pt_i_PackageName       => gcv_PackageName
                                            ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                            ,pt_i_ModuleMessage     => '      - No data found in EBS (source system) for Year/Period '
                                                                     ||ExtractYear_tbl(ExtractYear_idx)
                                                                     ||PeriodName_tbl(PeriodName_idx)||' Foe ledger '
                                                                     ||LedgerName_tbl(LedgerName_idx)
                                            ,pt_i_OracleError       => NULL
                                            );
                        ELSE
                            --
                            --
                            -- Current Period Name Parameter exists in the GL_PERIODS table
                            -- for the current Source Ledger Name and Extract Year so the
                            -- historical rates extract can proceed.
                            --
                            --
                            vb_PeriodAndYearMatch := TRUE;
                            --
                            xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => vt_SubEntity
                                             ,pt_i_MigrationSetID    => vt_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gcv_PackageName
                                             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - Extracting "'
                                                                      ||gct_Application
                                                                      ||' '
                                                                      ||vt_SubEntity
                                                                      ||'" for GL Ledger Name "'
                                                                      ||LedgerName_tbl(LedgerName_idx)
                                                                      ||'" and Year "'
                                                                      ||ExtractYear_tbl(ExtractYear_idx)
                                                                      ||'", Period Name "'
                                                                      ||PeriodName_tbl(PeriodName_idx)
                                                                      ||'".'
                                             ,pt_i_OracleError       => NULL
                                             );			
							*/
							
							xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => gct_SubEntity
                                             ,pt_i_MigrationSetID    => vt_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gcv_PackageName
                                             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - Extracting "'
                                                                      ||gct_Application
                                                                      ||' '
                                                                      ||gct_SubEntity
                                                                      ||'" for GL Ledger Name "'
                                                                      ||LedgerName_tbl(LedgerName_idx)
                                                                      ||'" and Period Name "'
                                                                      ||PeriodName_tbl(PeriodName_idx)
                                                                      ||'".'
                                             ,pt_i_OracleError       => NULL
                                             );		
		--
        gvv_ProgressIndicator := '0140';
        --
        OPEN GLHistoricalrates_cur(LedgerName_tbl(LedgerName_idx),PeriodName_tbl(PeriodName_idx));
        --
        gvv_ProgressIndicator := '0150';
        --
            LOOP
            --
            FETCH        GLHistoricalrates_cur
                BULK COLLECT
                INTO         gl_historicalrates_tbl
                LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
            --
                EXIT WHEN    gl_historicalrates_tbl.COUNT = 0;
            --
                xxmx_utilities_pkg.log_module_message
                        (
                        pt_i_ApplicationSuite  => gct_ApplicationSuite
                       ,pt_i_Application       => gct_Application
                       ,pt_i_BusinessEntity    => gct_BusinessEntity
                       ,pt_i_SubEntity         => gct_SubEntity
                       ,pt_i_MigrationSetID    => vt_MigrationSetID
                       ,pt_i_Phase             => ct_Phase
                       ,pt_i_Severity          => 'NOTIFICATION'
                       ,pt_i_PackageName       => gcv_PackageName
                       ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                       ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                       ,pt_i_ModuleMessage     => '    - Record Count '||gl_historicalrates_tbl.COUNT
                       ,pt_i_OracleError       => NULL
                        );
                                --			
            gvv_ProgressIndicator := '0160';
            --
            FORALL GLHistoricalrates_idx 
                IN 1..gl_historicalrates_tbl.COUNT
            --
                INSERT
                INTO   xxmx_stg.xxmx_gl_historical_rates_stg
                (
                                                               migration_set_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,ledger_name
                                                              ,import_action_code
															  ,segment1
															  ,segment2
															  ,segment3
															  ,segment4
															  ,segment5
															  ,segment6
															  ,segment7
															  ,segment8
															  ,segment9
															  ,segment10
															  ,segment11
															  ,segment12
															  ,segment13
															  ,segment14
															  ,segment15
															  ,segment16
															  ,segment17
															  ,segment18
															  ,segment19
															  ,segment20
															  ,segment21
															  ,segment22
															  ,segment23
															  ,segment24
															  ,segment25
															  ,segment26
															  ,segment27
															  ,segment28
															  ,segment29
															  ,segment30
															  ,period_name
															  ,target_currency_code
															  ,value_type_code
															  ,credit_amount_rate
															  ,auto_roll_forward_flag
															  ,attribute_category
															  ,attribute1
															  ,attribute2
															  ,attribute3
															  ,attribute4
															  ,attribute5

                )
                VALUES
                (
                                                               vt_MigrationSetID                                             -- migration_set_id
                                                              ,gvt_MigrationSetName                                          -- migration_set_name
                                                              ,'EXTRACTED'                                                   -- migration_status
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).ledger_name     -- ledger_name
															  ,gl_historicalrates_tbl(GLHistoricalrates_idx).import_action   --import_action
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment1        -- segment1
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment2        -- segment2
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment3        -- segment3
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment4        -- segment4
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment5        -- segment5
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment6        -- segment6
															  ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment7        -- segment7
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment8        -- segment8
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment9        -- segment9
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment10       -- segment10
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment11       -- segment11
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment12       -- segment12
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment13       -- segment13
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment14       -- segment14
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment15       -- segment15
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment16       -- segment16
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment17       -- segment17
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment18       -- segment18
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment19       -- segment19
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment20       -- segment20
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment21       -- segment21
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment22       -- segment22
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment23       -- segment23
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment24       -- segment24
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment25       -- segment25
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment26       -- segment26
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment27       -- segment27
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment28       -- segment28
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment29       -- segment29
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment30       -- segment30
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).period_name     --period_name
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).target_currency_code --target_currency_code                                                          -- attribute_date4
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).value_type_code    --value_type_code                                                          -- attribute_date5
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).credit_amount_rate --credit_amount_rate                                                          -- attribute_number1
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).auto_roll_forward_flag --auto_roll_forward_flag                                                          -- attribute_number2
                                                              ,NULL                                                          -- attribute_category
                                                              ,NULL                                                          -- attribute1
                                                              ,NULL                                                          -- attribute2
															  ,NULL                                                          -- attribute3
															  ,NULL                                                          -- attribute4
															  ,NULL                                                          -- attribute5
                );
                --
                --** END FORALL 
                --
            END LOOP; --** GLHistoricalrates_cur BULK COLLECT LOOP
            --
            gvv_ProgressIndicator := '0170';
            --
        CLOSE GLHistoricalrates_cur;

		 END LOOP; --** Period Name tbl LOOP
            --
            gvv_ProgressIndicator := '0180';
            --		 
		 END LOOP; --** Ledger scope tbl LOOP
        --
        gvv_ProgressIndicator := '0190';
        --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all GL Ledgers in the Migration Set.
                    */
                    --
                    gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                         (
                                          gct_StgSchema
                                         ,ct_StgTable
                                         ,vt_MigrationSetID
                                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                    COMMIT;
                    --
                    --** Update the migration details (Migration status will be automatically determined
                    --** in the called procedure dependant on the Phase and if an Error Message has been
                    --** passed).
                    --
                    gvv_ProgressIndicator := '0200';
                    --
                    --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
                    --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
                    --**
                    --**                  Removed "entity" from procedure_name.
                    --
                    xxmx_utilities_pkg.upd_migration_details
                         (
                          pt_i_MigrationSetID          => vt_MigrationSetID
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                    END IF;
               --
			ELSE
            --
            gvt_Severity      := 'ERROR';
            gvt_ModuleMessage := '- Migration Set not initialized.';
            --
            RAISE e_ModuleError;
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                    IF   GLHistoricalrates_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLHistoricalrates_cur;
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                    IF   GLHistoricalrates_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLHistoricalrates_cur;
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END gl_historical_rates_stg;
     --
     --
     procedure stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
     is
        CURSOR metadata_cur
        IS
         SELECT  Entity_package_name
                ,Stg_procedure_name
                ,BUSINESS_ENTITY
                ,SUB_ENTITY_SEQ
                ,sub_entity
         FROM    xxmx_migration_metadata a
         WHERE 	 application_suite = gct_ApplicationSuite
         AND   	 Application = gct_Application
         AND   	 business_entity = gct_BusinessEntity
         AND   	 a.enabled_flag = 'Y'
         ORDER BY
         Business_entity_seq,
         Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
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
          gvv_ReturnStatus  := '';
          --
          /*
          ** Clear Historical Rates Module Messages
          */
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
          gvv_ProgressIndicator := '0030';
          --
          /*
          ** Migration Set ID Generation
          */
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

END xxmx_gl_historical_rates_pkg;
/
