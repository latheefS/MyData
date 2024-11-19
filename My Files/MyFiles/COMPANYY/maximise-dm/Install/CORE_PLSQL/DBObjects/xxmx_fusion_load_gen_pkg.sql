CREATE OR REPLACE package xxmx_fusion_load_gen_pkg
AS 

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
     ** FILENAME  :  xxmx_fusion_load_gen_pkg.sql
     **
     ** FILEPATH  :
     **
     ** VERSION   :  1.2
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Pallavi 
     **
     ** PURPOSE   : This script creates the package which performs all Dynamic SQL
     **             processing for Cloudbridge.
     **
     ** NOTES     : This package belong to core Cloudbridge Structure. Cloudbridge will not support 
     **             any changes on made by Delivery Team on this package.
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
     ** xxmx_fusion_load_gen_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-Nov-2021  Pallavi              Created for Cloudbridge.
     **   1.1  23-JUN-2021  Pallavi              Changed log to show subentity
     **   1.2  28-JUL-2022  Pallavi              Added for PPM application Suite
     **   1.3  28-AUG-2022  Pallavi              Change to accomodate empty tables in the load.
     **   1.4  20-Feb-2023  Ayush Rathore       Changes done for HCM to improve load file generation
     **   1.5  16-OCt-2023  Shireesha TR        Added Iteration Parameter in main procedure
     **   1.6  25-Oct-2023  Shireesha TR        Added missing statement and parameter in main procedure    
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



    PROCEDURE generate_csv_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.File_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
                    ,pt_file_generated_by            IN      VARCHAR2 DEFAULT 'OIC'
                    ,pt_i_sub_entity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
                    ,pv_returnstatus            OUT VARCHAR2
                    ,pv_returnmessage           OUT VARCHAR2
                   );
    PROCEDURE generate_hdl_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.File_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
                    ,pt_file_generated_by            IN      VARCHAR2 DEFAULT 'OIC'
                    ,pt_i_sub_entity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
                    ,pv_returnstatus            OUT VARCHAR2
                    ,pv_returnmessage           OUT VARCHAR2
                   );

    PROCEDURE main
                    (
                     pv_i_application_suite     IN      VARCHAR2
                    ,pt_i_BusinessEntity        IN      xxmx_migration_metadata.business_entity%TYPE DEFAULT NULL
                    ,pt_i_sub_entity            IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
                    ,pt_i_instance_id             IN      VARCHAR2 DEFAULT NULL
					,pt_i_iteration             IN     VARCHAR2 DEFAULT NULL
                    ,pt_i_FileName             IN      xxmx_migration_metadata.data_file_name%TYPE DEFAULT NULL
                   );

    PROCEDURE xxmx_file_col_seq (p_xfm_Table_id IN VARCHAR2,pv_o_ReturnStatus OUT VARCHAR2);

END xxmx_fusion_load_gen_pkg;
/


CREATE OR REPLACE package body xxmx_fusion_load_gen_pkg
AS 
/*
    --//================================================================================
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
     ** xxmx_fusion_load_gen_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-Nov-2021  Pallavi              Created for Cloudbridge.
     **   1.1  23-JUN-2021  Pallavi              Changed log to show subentity
     **   1.2  28-JUL-2022  Pallavi              Added for PPM application Suite
     **   1.3  28-AUG-2022  Pallavi              Change to accomodate empty tables in the load.
     **   1.4  20-Feb-2023  Ayush Rathore       Changes done for HCM to improve load file generation
     **   1.5  16-OCt-2023  Shireesha TR        Added Iteration Parameter in main procedure
     **   1.6  25-Oct-2023  Shireesha TR        Added missing statement and parameter in main procedure    
     --//================================================================================
     */

        --
        --
        ----------------------------------------------------------
        -- generate_hdl_file For HCM Load
        ----------------------------------------------------------
        --
        --
        gv_file_Blob  blob;
        ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'FTP_OUTPUT';
        gvt_ApplicationSuite                  xxmx_migration_metadata.application_suite%TYPE:= 'XXMX';
        gvt_Application                       xxmx_migration_metadata.application%TYPE:='XXMX';
        gct_Phase                             xxmx_module_messages.phase%TYPE              := 'EXPORT';
        gvt_BusinessEntity          CONSTANT  xxmx_migration_metadata.business_entity%TYPE  := 'XXMX_CORE';
        vt_SchemaName                         VARCHAR2(20)                                 := 'XXMX_CORE';
        gct_PackageName             CONSTANT   VARCHAR2(30)                                 := 'XXMX_FUSION_LOAD_GEN_PKG';
        gvv_ProgressIndicator                 VARCHAR2(100); 
        gcn_BulkCollectLimit        CONSTANT NUMBER  := 20000; 

        TYPE t_File_columns IS VARRAY(50000) OF VARCHAR2(200) ;
        t_File_col t_File_columns         := t_File_columns();
        gvv_ReturnStatus                     VARCHAR2(1);
        gvt_ReturnMessage                    xxmx_module_messages.module_message%TYPE;
        gvt_ModuleMessage                    xxmx_module_messages.module_message%TYPE;
        gvt_OracleError                      xxmx_module_messages.oracle_error%TYPE;
        e_ModuleError                        EXCEPTION;


        PROCEDURE XXMX_FILE_COL_SEQ (p_xfm_Table_id IN VARCHAR2,pv_o_ReturnStatus OUT VARCHAR2)
        IS 

        cursor c1
        IS 
        Select   length(regexp_replace(TRIM(SUBSTR(excel_file_header,1,50000)), '[^,]'))/ length(',') cnt
        --length(regexp_replace(TRIM(dbms_lob.SUBSTR(excel_file_header,50000)), '[^,]')) / length(',') cnt
                ,excel_file_header
                ,b.xfm_table_id
        from xxmx_dm_subentity_file_map a,
        xxmx_migration_metadata m,
        xxmx_xfm_Table_columns b,
        xxmx_xfm_tables c
        where a.sub_entity = m.sub_entity
        and b.xfm_table_id = p_xfm_Table_id
        and c.table_name = UPPER(m.xfm_table)
        and b.xfm_table_id = c.xfm_table_id
        and rownum=1;

        lv_test VARCHAR2(200);
        lv_sql CLOB;
        cv_ProcOrFuncName                    CONSTANT VARCHAR2(30)                            := 'xxmx_file_col_seq';
        total_rec NUMBER;

        BEGIN 
            gvv_ProgressIndicator:= '0010';
            t_File_col  := t_File_columns();


            FOR r IN C1
            LOOP
                 t_File_col.EXTEND(r.cnt+1);
                 gvv_ProgressIndicator:= '0015';
                 total_rec := r.cnt;
                 FOR i IN 1..r.cnt+1
                 LOOP
                    lv_test := NULL;
                    gvv_ProgressIndicator:= '0020';
                    IF( i=1) THEN 
                        gvv_ProgressIndicator:= '0025';
                        /*lv_sql:= 'Select REPLACE(substr('''||r.excel_file_header||''','||i||',INSTR('''||r.excel_file_header||''','','','||i||','||i||')),'','','''')'||
                  		from dual';*/
                        lv_sql:= 'Select REPLACE(substr(:a,:b,INSTR(:c,'','',:d,:d)),'','','''')'||
                                ' from dual';

                        EXECUTE IMMEDIATE lv_sql INTO lv_test using r.excel_file_header,i,r.excel_file_header,i,i;
                        gvv_ProgressIndicator:= '0030';

                    ELSIf (i= (total_rec+1)) THEN 
                        lv_sql := 'SELECT substr(:a,INSTR(:b,'','',1,:c)+1,length(:d)) from dual';
                        EXECUTE IMMEDIATE lv_sql INTO lv_test using r.excel_file_header,r.excel_file_header,total_rec,r.excel_file_header;
                    ELSE 
                       gvv_ProgressIndicator:= '0035';

                       lv_sql:= 'SELECT substr(:a,INSTR(:b,'','',1,:c-1)+1,(INSTR(:d,'','',1,:e))-(INSTR(:f,'','',1,:g-1)+1)) from dual';
                     --DBMS_OUTPUT.PUT_LINE(lv_sql);
                       EXECUTE IMMEDIATE lv_sql INTO lv_test using r.excel_file_header,
                                                                   r.excel_file_header,
                                                                   i,
                                                                   r.excel_file_header,
                                                                   i,
                                                                   r.excel_file_header,
                                                                   i;

                       gvv_ProgressIndicator:= '0040';

                    END IF;

                    IF( lv_test IS NOT NULL) THEN
                        gvv_ProgressIndicator:= '0045';
                        gvt_ModuleMessage:= 'Field_name '||lv_test;
                        t_File_col(i) := lv_test;
                        DBMS_OUTPUT.PUT_LINE(lv_test);
                    ELSE 
                        gvv_ProgressIndicator:= '0050'; 
                        gvt_ModuleMessage := 'Column with null value';
                        --raise e_ModuleError;
                    END IF;
                END LOOP;
             END LOOP;

             gvv_ProgressIndicator:= '0055'; 
             pv_o_ReturnStatus := 'S';

           EXCEPTION
           WHEN e_ModuleError THEN
                 pv_o_ReturnStatus := 'E';
                 xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => gvt_ApplicationSuite
                        ,pt_i_Application         => gvt_Application
                        ,pt_i_BusinessEntity      => gvt_BusinessEntity
                        ,pt_i_SubEntity           =>  'ALL'
                        ,pt_i_MigrationSetID      => 0
                        ,pt_i_Phase               => gct_phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gct_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                        ,pt_i_OracleError         => gvt_ReturnMessage       );    

           WHEN OTHERS THEN 
           --
                 pv_o_ReturnStatus := 'E';
                 gvt_OracleError := SUBSTR(SQLERRM||'-'||SQLCODE,1,500);
                 xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => gvt_ApplicationSuite
                        ,pt_i_Application         => gvt_Application
                        ,pt_i_BusinessEntity      => gvt_BusinessEntity
                        ,pt_i_SubEntity           =>  'ALL'
                        ,pt_i_MigrationSetID      => 0
                        ,pt_i_Phase               => gct_phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gct_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                        ,pt_i_OracleError         => gvt_OracleError       );    
        END;


        /* Used to generate HCM File */
        PROCEDURE generate_hdl_file
                    (
                    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.File_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
                    ,pt_file_generated_by            IN      VARCHAR2 DEFAULT 'OIC'
                    ,pt_i_sub_entity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
                    ,pv_returnstatus            OUT VARCHAR2
                    ,pv_returnmessage           OUT VARCHAR2
                   )
        IS
          --
          -- *********************
          --  CURSOR Declarations
          -- *********************
            CURSOR c_file_components (p_applicationsuite Varchar2,p_application Varchar2)
            IS
            Select mm.Sub_entity, 
                   mm.Metadata_id,
                   mm.business_entity,
                   mm.stg_Table stg_table_name,
                  UPPER( mm.xfm_table) xfm_table_name,
                   xt.xfm_table_id,
                   xt.fusion_template_name,
                   xt.fusion_template_sheet_name,
                   hdm.action_code,
                   hdm.column_name,
                   REPLACE(mm.seq_in_fbdi_data,',','||''-''||') seq_in_fbdi_data,        -- Added new column for batching                
                   mm.batch_load,                                                       -- Added new column for batching
                   xt.common_load_column                                                 -- Added new column for batching
           from xxmx_migration_metadata mm, xxmx_xfm_tables xt, XXMX_HCM_DATAFILE_XFM_MAP hdm
            where mm.application_suite = p_applicationsuite
            and mm.application = p_application
            and hdm.data_file_name = DECODE(pt_i_FileName,'ALL', hdm.data_file_name, pt_i_FileName)
            and mm.stg_table is not null
            AND mm.enabled_flag = 'Y'
            AND hdm.enabled_flag = 'Y'
            AND mm.business_entity=hdm.business_entity
            AND mm.sub_entity = hdm.sub_entity
            AND mm.metadata_id = xt.metadata_id
	UNION
                
                 Select mm.Sub_entity, 
                   mm.Metadata_id,
                   mm.business_entity,
                   hdm.stg_Table stg_table_name,
                  UPPER( hdm.xfm_table) xfm_table_name,
                   xt.xfm_table_id,
                   xt.fusion_template_name,
                   xt.fusion_template_sheet_name,
                   hdm.action_code,
                   hdm.column_name,
                   REPLACE(mm.seq_in_fbdi_data,',','||''-''||') seq_in_fbdi_data,        -- Added new column for batching               
                   mm.batch_load,                                                       -- Added new column for batching
                   xt.common_load_column                                                 -- Added new column for batching
                from xxmx_migration_metadata mm,  xxmx_xfm_tables xt, XXMX_HCM_DATAFILE_XFM_MAP hdm
                where mm.application_suite = p_applicationsuite
                and mm.application = p_application
                and hdm.data_file_name = DECODE(pt_i_FileName,'ALL', hdm.data_file_name, pt_i_FileName)
                and mm.stg_table is null
                and hdm.stg_table is not null
                AND mm.enabled_flag = 'Y'
                AND hdm.enabled_flag = 'Y'
                AND mm.business_entity=hdm.business_entity
                AND mm.sub_entity = hdm.sub_entity
                AND hdm.xfm_table=xt.table_name;



        --
            cursor c_missing_values ( p_xfm_table in VARCHAR2) is
            select  column_name
                    ,fusion_template_field_name
                    ,field_delimiter
            from    xxmx_xfm_table_columns xtc, 
                    xxmx_xfm_tables xt
            where   xt.table_name= p_xfm_table
            AND     xtc.xfm_table_id = xt.xfm_table_id
            and     xtc.include_in_outbound_file = 'Y'
            and     xtc.mandatory                = 'Y';
        --
            cursor C_Hdl_Fusion_Common_Cur ( p_xfm_table_id in number) is
            select  column_name,fusion_template_field_name,data_type,field_delimiter
            from    xxmx_xfm_table_columns xtc, xxmx_xfm_tables xt
            where    xt.xfm_Table_id  = xtc.xfm_table_id
            and     xt.xfm_table_id = p_xfm_table_id
            and     include_in_outbound_file = 'Y'
            AND     Column_name IN('METADATA',
                                   'OBJECT_NAME',
                                   'OBJECTNAME',
                                   'SOURCESYSTEMOWNER',
                                   'SOURCESYSTEMID',
                                   'SOURCE_SYSTEM_OWNER',
                                   'SOURCE_SYSTEM_ID')
            order by column_name;

            cursor c_file_columns ( p_xfm_table_id in number) is
            select  column_name,fusion_template_field_name,data_type,field_delimiter
            from    xxmx_xfm_table_columns xtc, xxmx_xfm_tables xt
            where    xt.xfm_Table_id  = xtc.xfm_table_id
            and     xt.xfm_table_id = p_xfm_table_id
            and     include_in_outbound_file = 'Y'
            AND     Column_name NOT IN('METADATA',
                                   'OBJECT_NAME',
                                   'OBJECTNAME',
                                   'SOURCESYSTEMOWNER',
                                   'SOURCESYSTEMID',
                                   'SOURCE_SYSTEM_OWNER',
                                   'SOURCE_SYSTEM_ID')
            order by xfm_column_seq
            ;


        --
        --
         /************************
         ** Constant Declarations
         *************************/
          --
          cv_ProcOrFuncName           CONSTANT VARCHAR2(30)                            := 'generate_file';
          vt_sub_entity                        xxmx_migration_metadata.sub_entity%TYPE :='ALL';
          gct_phase                   CONSTANT xxmx_module_messages.phase%TYPE         := 'EXPORT';

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
          gvt_migrationsetid                   xxmx_migration_headers.migration_set_id%TYPE;
          gvt_Severity                         xxmx_module_messages .severity%TYPE;
          vv_hdl_file_header                   VARCHAR2(30000);
          vv_hdl_file_header_mand              VARCHAR2(2000);
          vv_error_message                     VARCHAR2(80);
          vv_stop_processing                   VARCHAR2(1);
          vv_column_name                       VARCHAR2(100);
          gvv_SQLStatement                     VARCHAR2(32000);
          gvv_SQLPreString                     VARCHAR2(8000);
          gvv_ProgressIndicator                VARCHAR2(100); 
          gvv_stop_processing                  VARCHAR2(5);
          gvv_sqlresult_num                    NUMBER;
          vt_SchemaName                        VARCHAR2(10):= 'XXMX_CORE';
          vt_procedure_name                    VARCHAR2(50);
          vt_custom_pkg_name                   VARCHAR2(50);
          gvcdynamicSQL                        VARCHAR2(32000);


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
          
		  type p_rowid is table of varchar2(1000) index by binary_integer;
          v_rowid                 p_rowid;

          type p_batchname is table of varchar2(1000) index by binary_integer;
          v_batchname                 p_batchname;
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
        BEGIN
        --
        -- ****************************** Initialise Procedure Global Variables ******************************
        --
        gvv_ProgressIndicator := '0010';

        --
        gvv_ReturnStatus  := 'S';
        pv_returnstatus   := 'S';
        --
        -- Delete any MODULE messages FROM previous executions
        -- FOR the Business Entity and Business Entity Level
        --
        xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => vt_Applicationsuite
               ,pt_i_Application      => vt_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity 
               ,pt_i_SubEntity        => pt_i_sub_entity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages FOR all previous runs are deleted.
               ,pt_i_Phase            => gct_phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => vt_Applicationsuite
                    ,pt_i_Application       => vt_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity 
                    ,pt_i_SubEntity         => pt_i_sub_entity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gct_phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
            --
            RAISE e_ModuleError;
            --
        END IF;
        --
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
              ,pt_i_LookupCode    => pt_i_BusinessEntity
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
                    pt_i_BusinessEntity   => pt_i_BusinessEntity
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

         gvv_ProgressIndicator := '0030';

        --
        xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => vt_Applicationsuite
               ,pt_i_Application       => vt_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity 
               ,pt_i_SubEntity         => pt_i_sub_entity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => gct_phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gct_PackageName||'.'||cv_ProcOrFuncName||'" initiated.',pt_i_OracleError=> NULL
               );
        --
        --gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        gvv_ProgressIndicator := '0040';
        --
        xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => vt_Applicationsuite
                              ,pt_i_Application       => vt_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity 
                              ,pt_i_SubEntity         => pt_i_sub_entity
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
        gvv_ProgressIndicator := '0050';
        --
        xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => vt_Applicationsuite
                              ,pt_i_Application       => vt_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_sub_entity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gct_phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => 'Calling open_hdl '||gvt_MigrationSetName||' File Name '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );
        --
        -- ****************************** Start generating the HDL data file ******************************
        --
        gvv_ProgressIndicator := '0060';
        --DBMS_OUTPUT.PUT_LINE('TEST_DIR123 '||vv_file_dir);
        --
     /*   begin
            vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                            (vt_Applicationsuite
                            ,vt_Application
                            ,pt_i_BusinessEntity
                            ,ct_file_location_type
                            );

            SELECT file_location
            INTO vv_file_dir
            FROM xxmx_file_locations
            WHERE application_suite = vt_Applicationsuite
            AND application       = vt_Application
            AND business_entity   = pt_i_BusinessEntity
            AND used_by   = 'PLSQL'
            AND file_location_type = ct_file_location_type;                                                

            --DBMS_OUTPUT.PUT_LINE('TEST_DIR '||vv_file_dir);

        exception
            when others then
                xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => vt_Applicationsuite
                              ,pt_i_Application       => vt_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_sub_entity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gct_phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => 'No directory was found in table xxmx_file_locations for APPLICATION:'||vt_Applicationsuite
                              ,pt_i_OracleError       => NULL
                              );

        end;*/
        --

        --


        For r_file_component in c_file_components(VT_APPLICATIONSUITE ,VT_APPLICATION ) 
                loop

                DBMS_OUTPUT.PUT_LINE(VT_APPLICATIONSUITE||'  '||VT_APPLICATION);

                gvv_sqlstatement := 'SELECT max(migration_set_id) from '
                                            ||r_file_component.xfm_table_name;

                EXECUTE IMMEDIATE gvv_sqlstatement INTO gvt_migrationsetid;

                        --DBMS_OUTPUT.PUT_LINE(   gvv_sqlstatement);
                 BEGIN   

                    DELETE FROM xxmx_hdl_file_temp WHERE  UPPER(file_name) = UPPER(pt_i_FileName)  and  UPPER(line_type) = UPPER(r_file_component.fusion_template_sheet_name);

                    --
                    gvv_ProgressIndicator := '0070';
                    gvv_sqlresult_num     := NULL;
                    gvv_stop_processing   := NULL;
                    --
                    -- Check Mandatory Columns in xfm_table
                    --

                    gvv_sqlstatement :=    'select  Count(1)
                                            from    xxmx_xfm_table_columns xtc, 
                                                    xxmx_xfm_tables xt
                                            where    xt.table_name= '''||r_file_component.xfm_table_name
                                            ||''' AND     xtc.xfm_table_id = xt.xfm_table_id
                                                AND     xtc.include_in_outbound_file = ''Y'''
                                         ;
                    DBMS_OUTPUT.PUT_LINE(   gvv_sqlstatement);                              

                    OPEN MandColumnData_cur FOR gvv_sqlstatement;
                    FETCH MandColumnData_cur INTO gvv_sqlresult_num;

                    IF gvv_sqlresult_num = 0 THEN

                       gvv_ProgressIndicator := '0075';
                       gvv_stop_processing := 'Y';
                       gvt_ModuleMessage := 'No Columns are marked for Fusion Outbound File in xxmx_xfm_table_columns';

                        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => vt_Applicationsuite
                         ,pt_i_Application       => vt_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_sub_entity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                      -- raise e_ModuleError;       
                    END IF;

                    Close MandColumnData_cur;
                --
                    gvv_ProgressIndicator := '0080';
                    gvv_sqlresult_num     := NULL;
                    gvv_stop_processing   := NULL;
                    --
                    -- Check Fusion HCM Mandatory Columns- METADATA in xfm_table
                    --

                    gvv_sqlstatement :=    'select  Count(1)
                                            from    xxmx_xfm_table_columns xtc, 
                                                    xxmx_xfm_tables xt
                                            where    xt.table_name= '''|| r_file_component.xfm_table_name
                                            ||''' AND     xtc.xfm_table_id = xt.xfm_table_id
                                                AND     xtc.include_in_outbound_file = ''Y'''
                                            ||' AND     Column_name IN('
                                            ||'''METADATA'',
                                              ''OBJECT_NAME'',
                                              ''OBJECTNAME'',
                                              ''SOURCESYSTEMOWNER'',
                                              ''SOURCESYSTEMID'',
                                              ''SOURCE_SYSTEM_OWNER'',
                                              ''SOURCE_SYSTEM_ID'')';

--                    DBMS_OUTPUT.PUT_LINE(   gvv_sqlstatement);

                    OPEN MandColumnData_cur for gvv_sqlstatement;
                    FETCH MandColumnData_cur INTO gvv_sqlresult_num;


		   IF gvv_sqlresult_num <2  THEN

                       gvv_ProgressIndicator := '0085';
                       gvv_stop_processing := 'Y';
                       gvt_ModuleMessage := 'HDL Mandatory Columns are not marked as mandatory like METADATA, SourceSystemID in xxmx_xfm_table_columns ';

                        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => vt_Applicationsuite
                         ,pt_i_Application       => vt_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_sub_entity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                      -- raise e_ModuleError;   


                    END IF;

                    CLOSE MandColumnData_cur;
                    --
                    -- Check for missing values in the mandatory columns
                    --
                    FOR r_missing_values 
                    IN c_missing_values(r_file_component.xfm_table_name) 
                    LOOP

                        gvv_sqlstatement := 'SELECT count(1) from '
                                            ||r_file_component.xfm_table_name
                                            ||' WHERE '
                                            ||r_missing_values.column_name
                                            ||' IS NULL';

                        EXECUTE IMMEDIATE gvv_sqlstatement INTO gvv_sqlresult_num;

                        --DBMS_OUTPUT.PUT_LINE(   gvv_sqlstatement);

                        IF gvv_sqlresult_num > 0 THEN

                                gvv_ProgressIndicator := '0080';
                                gvv_stop_processing := 'Y';
                                gvt_ModuleMessage := 'Column '||r_missing_values.column_name||' is marked as Mandatory with Null values in the XFM table :'||r_file_component.xfm_table_name;
                                 xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => vt_Applicationsuite
                                  ,pt_i_Application       => vt_Application
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                  ,pt_i_SubEntity         => pt_i_sub_entity
                                  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                  ,pt_i_Phase             => gct_phase
                                  ,pt_i_Severity          => 'ERROR'
                                  ,pt_i_PackageName       => gct_PackageName
                                  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => gvt_ModuleMessage
                                  ,pt_i_OracleError       => NULL
                                  );
                           -- raise e_ModuleError;

                        END IF;

                    END LOOP;

                    IF vv_stop_processing = 'Y' THEN
                        gvt_Severity              := 'ERROR';
                        gvt_ModuleMessage         := 'Extract file has not created. Check xxmx_module_messages for errors.';
                        RAISE e_moduleerror;
                    END IF;


                    --
                    -- Build the SQL for the extract and the header for the output file
                    --
                    v_hdr_flag := NULL;
                    gvv_sqlstatement:= NULL;
                    vv_hdl_file_header:= NULL;
                    vv_hdl_file_header_mand := NULL;

                    gvv_sqlstatement := 'SELECT count(1) from '||r_file_component.xfm_table_name;

                    DBMS_OUTPUT.PUT_LINE(   gvv_sqlstatement);
                    OPEN MandColumnData_cur FOR gvv_sqlstatement;

                    FETCH MandColumnData_cur INTO gvv_sqlresult_num;



                    IF( gvv_sqlresult_num <> 0) THEN 
                        DBMS_OUTPUT.PUT_LINE('ERROR');

                            -- Generate HDL Mandatory columns
                            -- Adding header to the files and to sql statement
                            -- to extract the data from xfm tables

                            FOR c_hdl_fusion_common_rec IN c_hdl_fusion_common_cur (r_file_component.xfm_table_id) 
                            LOOP
                               v_hdr_flag:= 'Y';

                               gvv_ProgressIndicator := '0095';
                               gvv_stop_processing := 'Y';
                               gvt_ModuleMessage := 'Adding mandatory Fusion columns to fusion File :'||c_hdl_fusion_common_rec.fusion_template_field_name;
                                xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => vt_Applicationsuite
                                 ,pt_i_Application       => vt_Application
                                 ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                 ,pt_i_SubEntity         => pt_i_sub_entity
                                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                 ,pt_i_Phase             => gct_phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gct_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => gvt_ModuleMessage
                                 ,pt_i_OracleError       => NULL
                                 );

                                    CASE c_hdl_fusion_common_cur%rowcount
                                    when 1 then
                                        gvv_SQLStatement := 'select '||c_hdl_fusion_common_rec.column_name||'||'''||c_hdl_fusion_common_rec.field_delimiter||'''||';
                                        vv_hdl_file_header_mand := vv_hdl_file_header_mand||c_hdl_fusion_common_rec.fusion_template_field_name;
                                    else
                                        vv_hdl_file_header_mand := vv_hdl_file_header_mand||c_hdl_fusion_common_rec.field_delimiter||c_hdl_fusion_common_rec.fusion_template_field_name;
                                        gvv_SQLStatement:=gvv_SQLStatement||c_hdl_fusion_common_rec.column_name||'||'''||c_hdl_fusion_common_rec.field_delimiter||'''||';

                                    END CASE;

                            END LOOP; -- c_hdl_fusion_common_rec


                            vv_hdl_file_header := vv_hdl_file_header_mand;

                             DBMS_OUTPUT.PUT_LINE(   vv_hdl_file_header);

                            FOR r_file_column  IN c_file_columns(r_file_component.xfm_table_id) 
                            LOOP

                               IF( v_hdr_flag is NULL ) THEN
                                  gvv_ProgressIndicator := '0097';
                                  gvv_stop_processing := 'Y';
                                  gvt_ModuleMessage := 'Mandatory Fusion columns are not added to  fusion File :'||r_file_column.fusion_template_field_name;
                                   xxmx_utilities_pkg.log_module_message
                                    (
                                     pt_i_ApplicationSuite  => vt_Applicationsuite
                                    ,pt_i_Application       => vt_Application
                                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                    ,pt_i_SubEntity         => pt_i_sub_entity
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
                               END IF;
                                IF r_file_column.data_type = 'DATE' THEN
                                        vv_column_name := 'to_char('||r_file_column.column_name||',''YYYY/MM/DD'')';
                                ELSE 
                                        vv_column_name := r_file_column.column_name;
                                END IF;

                                CASE c_file_columns%rowcount
                                    when 1 then
                                        vv_hdl_file_header := vv_hdl_file_header||'|'||r_file_column.fusion_template_field_name;
                                        gvv_SQLStatement := gvv_SQLStatement||vv_column_name||'||'''||r_file_column.field_delimiter||'''||';
                                    else
                                        gvv_SQLStatement := gvv_SQLStatement||vv_column_name||'||'''||r_file_column.field_delimiter||'''||';
                                        vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;
                                END CASE;

                            END LOOP; -- r_file_column

                            gvv_SQLStatement:= substr(gvv_SQLStatement,0,LENGTH(gvv_SQLStatement)-7);

                            --gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name;
                            
                             -- Added Batch value --
IF ( nvl(r_file_component.batch_load, 'N') = 'N' ) THEN

                -- Added new column for batch_value
    gvv_sqlstatement := gvv_sqlstatement
                        || ' , '
                        || nvl(r_file_component.seq_in_fbdi_data, 'NULL')
                        || ' , NULL from '
                        || r_file_component.xfm_table_name;
ELSE 

                -- Added new column for batch_value
    gvv_sqlstatement := gvv_sqlstatement
                        || ' , '
                        || nvl(r_file_component.seq_in_fbdi_data, r_file_component.common_load_column)
                        || ', batch_name from '
                        || r_file_component.xfm_table_name;
END IF;

dbms_output.put_line(gvv_sqlstatement);
                            
                            -- End * Added Batch value--
			IF(r_file_component.action_code IS NOT NULL)
			  THEN 
                                gvv_sqlstatement := gvv_sqlstatement||' WHERE '||r_file_component.COLUMN_NAME||' IN('||r_file_component.action_code||')';
                                
                            END IF;

                            DBMS_OUTPUT.PUT_LINE(   vv_hdl_file_header);

                            DBMS_OUTPUT.PUT_LINE(   gvv_sqlstatement);

                            --
                            gvv_ProgressIndicator := '0100';
                            --
                            xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => vt_Applicationsuite
                                  ,pt_i_Application       => vt_Application
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                  ,pt_i_SubEntity         => pt_i_sub_entity
                                  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                  ,pt_i_Phase             => gct_phase
                                  ,pt_i_Severity          => 'NOTIFICATION'
                                  ,pt_i_PackageName       => gct_PackageName
                                  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => SUBSTR('SQL= '||gvv_SQLStatement,1,4000)
                                  ,pt_i_OracleError       => NULL
                                  );
                            xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => vt_Applicationsuite
                                  ,pt_i_Application       => vt_Application
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                  ,pt_i_SubEntity         => pt_i_sub_entity
                                  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                  ,pt_i_Phase             => gct_phase
                                  ,pt_i_Severity          => 'NOTIFICATION'
                                  ,pt_i_PackageName       => gct_PackageName
                                  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => SUBSTR('Header='||vv_hdl_file_header,1,4000)
                                  ,pt_i_OracleError       => NULL
                                  );
                            --
                            gvv_ProgressIndicator := '0105';


                            --
                            gvv_ProgressIndicator := '0110';
                            --
                            -- Open cusrsor using the sql in gvv_SQLStatement
                            open r_data for gvv_sqlstatement;
                            fetch r_data bulk collect into g_extract_data,v_rowid,v_batchname limit     gcn_BulkCollectLimit   ; -- Added new column;
                            close r_data;
                            --
                            gvv_ProgressIndicator := '0115';
                            xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => vt_Applicationsuite
                                  ,pt_i_Application       => vt_Application
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                  ,pt_i_SubEntity         => pt_i_sub_entity
                                  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                  ,pt_i_Phase             => gct_phase
                                  ,pt_i_Severity          => 'NOTIFICATION'
                                  ,pt_i_PackageName       => gct_PackageName
                                  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => g_extract_data.COUNT
                                  ,pt_i_OracleError       => NULL
                                  );
                            --

                            if g_extract_data.COUNT = 0 THEN
                                gvv_ProgressIndicator := '0120';

                                gvt_ModuleMessage := 'No Data is XFM table '||r_file_component.xfm_table_name;
                                 xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => vt_Applicationsuite
                                 ,pt_i_Application       => vt_Application
                                 ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                 ,pt_i_SubEntity         => pt_i_sub_entity
                                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                 ,pt_i_Phase             => gct_phase
                                 ,pt_i_Severity          => 'ERROR'
                                 ,pt_i_PackageName       => gct_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => gvt_ModuleMessage
                                 ,pt_i_OracleError       => NULL
                                 );
                                raise e_dataerror;
                            END IF;
                            --
                            -- Write into data file
                            -- 1. Write the header
                            gvv_ProgressIndicator := '0125';

                           IF( pt_file_generated_by = 'OIC') THEN -- Added for Both OIC And PLSQL
                                 insert into xxmx_hdl_file_temp 
                                ( file_name, line_type, line_content, business_entity)
                                values 
                                (pt_i_FileName,r_file_component.fusion_template_sheet_name, vv_hdl_file_header, pt_i_BusinessEntity); 

                              FORALL i IN 1..g_extract_data.COUNT
                                  INSERT INTO xxmx_hdl_file_temp(file_name, line_type, line_content,status,Batch_name,batch_value,business_entity) -- added new column
                                  VALUES (pt_i_FileName,r_file_component.fusion_template_sheet_name,g_extract_data(i),NULL,v_batchname(i),v_rowid(i),pt_i_BusinessEntity ); -- added new column);

								commit;
                              --Commented by DG on 20/01/22 for testing
                           ELSE  -- Added for PLSQL

                              --
                            -- Open the extract data file
                              xxmx_hdl_utilities_pkg.open_hdl 
                                    ('Cloudbridge'
                                    ,pt_i_BusinessEntity
                                    ,pt_i_FileName
                                    ,vv_file_dir
                                    ,vv_file_type
                                    );

                               if g_extract_data.COUNT > 0 THEN
                                   -- Write the Business Entity header
                                   xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',r_file_component.fusion_template_sheet_name,vv_hdl_file_header,'M','Y');
                               END IF;

                               -- 2. Write the data
                               gvv_ProgressIndicator := '0126';
                               for i IN 1..g_extract_data.COUNT loop
                                   xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',r_file_component.fusion_template_sheet_name,g_extract_data(i),'M','Y');
                               END LOOP; 

                               g_extract_data.DELETE;
                               commit;
                               --
                               -- Close the file handler
                               gvv_ProgressIndicator := '0130';
                               xxmx_hdl_utilities_pkg.CLOSE_hdl(pv_ftp_enabled => 'Y');
                               --
                           END IF;

                  ELSE 
                        gvv_ProgressIndicator := '0085';
                        gvv_stop_processing := 'Y';




                END IF;  -- IF( gvv_sqlresult_num <> 0)


                 EXCEPTION 
                 WHEN e_dataerror THEN

                    xxmx_utilities_pkg.log_module_message
                          (
                           pt_i_ApplicationSuite  => vt_Applicationsuite
                          ,pt_i_Application       => vt_Application
                          ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                          ,pt_i_SubEntity         => pt_i_sub_entity
                          ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                          ,pt_i_Phase             => gct_phase
                          ,pt_i_Severity          => 'ERROR'
                          ,pt_i_PackageName       => gct_PackageName
                          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => gvt_ModuleMessage
                          ,pt_i_OracleError       => NULL
                          );
                 END;

                END LOOP;



        --
        EXCEPTION
            WHEN e_nodata THEN 
            --
                ROLLBACK;
            pv_returnstatus := 'F';
            pv_returnmessage := NVL(gvt_ModuleMessage,gvt_ReturnMessage);
            xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => vt_Applicationsuite
                        ,pt_i_Application         => vt_Application
                        ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                        ,pt_i_SubEntity           =>  pt_i_sub_entity
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
                ROLLBACK;

               pv_returnstatus := 'F';
               pv_returnmessage := NVL(gvt_ModuleMessage,gvt_ReturnMessage);
                    --
            xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => vt_Applicationsuite
                        ,pt_i_Application         => vt_Application
                        ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                        ,pt_i_SubEntity           =>  pt_i_sub_entity
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                        ,pt_i_Phase               => gct_phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gct_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     
                --
               -- RAISE;
                --** END e_ModuleError Exception
                --

            WHEN OTHERS THEN
                --
                ROLLBACK;
               pv_returnstatus := 'F';
                --
               gvt_OracleError := SUBSTR(
                                            SQLERRM
                                        ||'** ERROR_BACKTRACE: '
                                        ||dbms_utility.format_error_backtrace
                                        ,1
                                        ,4000
                                        );
              pv_returnmessage := SUBSTR(gvt_OracleError,1,100);
                --
                           xxmx_utilities_pkg.log_module_message(  
                            pt_i_ApplicationSuite    => vt_ApplicationSuite
                           ,pt_i_Application         => vt_Application
                           ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                           ,pt_i_SubEntity           =>  pt_i_sub_entity
                           ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                           ,pt_i_Phase               => gct_phase
                           ,pt_i_Severity            => 'ERROR'
                           ,pt_i_PackageName         => gct_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'Oracle Error'
                           ,pt_i_OracleError         => gvt_OracleError      
                           );     

                --
                --RAISE;
                -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
        END generate_hdl_file;
        --
        --
        ----------------------------------------------------------
        -- generate_csv_file For FBDI Load
        ----------------------------------------------------------
        --
        --
        PROCEDURE generate_csv_file
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_FileSetID                  IN      xxmx_migration_headers.File_set_id%TYPE
                        ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                        ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
                        ,pt_file_generated_by            IN      VARCHAR2 DEFAULT 'OIC'
                        ,pt_i_sub_entity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
                        ,pv_returnstatus            OUT VARCHAR2
                        ,pv_returnmessage           OUT VARCHAR2
                       )
         IS
              --
              -- *********************
              --  CURSOR Declarations
              -- *********************
                CURSOR c_file_components (p_applicationsuite Varchar2,p_application Varchar2)
                IS
                Select mm.Sub_entity, 
                       mm.Metadata_id,
                       mm.business_entity,
                       mm.stg_Table stg_table_name,
                      UPPER( mm.xfm_table) xfm_table_name,
                       xt.xfm_table_id,
                       xt.fusion_template_name,
                       xt.fusion_template_sheet_name,
                       mm.file_group_number,
                     REPLACE(mm.seq_in_fbdi_data,',','||''-''||') seq_in_fbdi_data,        -- Added new column                
                       mm.batch_load,
                       xt.common_load_column
                from xxmx_migration_metadata mm, xxmx_xfm_tables xt
                where mm.application_suite = p_applicationsuite
                and mm.application = p_application
                and mm.Business_entity = pt_i_BusinessEntity
                and mm.sub_entity = DECODE(pt_i_sub_entity,'ALL', mm.sub_entity, pt_i_sub_entity)
                and mm.stg_table is not null
                AND mm.enabled_flag = 'Y'
                AND mm.metadata_id = xt.metadata_id
                AND xt.fusion_template_name = NVL(pt_i_FileName,xt.fusion_template_name);



            --
                cursor c_missing_values ( p_xfm_table in VARCHAR2) is
                select  column_name
                        ,fusion_template_field_name
                        ,field_delimiter
                from    xxmx_xfm_table_columns xtc, 
                        xxmx_xfm_tables xt
                where   xt.table_name= p_xfm_table
                AND     xtc.xfm_table_id = xt.xfm_table_id
                and     xtc.include_in_outbound_file = 'Y'
                and     xtc.mandatory                = 'Y';
            --

                CURSOR c_file_columns ( p_xfm_table_id IN NUMBER,p_column_name IN VARCHAR2) is
                SELECT  column_name,
                        fusion_template_field_name,
                        data_type,
                        field_delimiter
                FROM    xxmx_xfm_table_columns xtc, xxmx_xfm_tables xt
                WHERE   xt.xfm_Table_id  = xtc.xfm_table_id
                AND     xt.xfm_table_id = p_xfm_table_id
                AND     UPPER(xtc.COLUMN_NAME) = NVL(UPPER(p_column_name),xtc.COLUMN_NAME)
                --AND     include_in_outbound_file = DECODE(UPPER(p_column_name),NULL,'Y',include_in_outbound_file)
                --order by xfm_column_seq
                ;

               CURSOR csv_fileCol(p_xfm_Table_id NUMBER)
               IS 
               SELECT  column_name,
                        fusion_template_field_name,
                        data_type,
                        field_delimiter
                FROM    xxmx_xfm_table_columns xtc, xxmx_xfm_tables xt
                WHERE   xt.xfm_Table_id  = xtc.xfm_table_id 
                AND     include_in_outbound_file = 'Y'
                AND     xt.xfm_table_id = p_xfm_Table_id
                order by xfm_column_seq;

            --
            --
             /************************
             ** Constant Declarations
             *************************/
              --

              cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'generate_csv_file';

              vt_ext                      CONSTANT  VARCHAR2(10)                                := '.csv';
              gct_phase                   CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXPORT';
              g_zipped_blob               blob;

              vv_file_type                          VARCHAR2(10) := 'M';
              vv_file_dir                           xxmx_file_locations.file_location%TYPE;
              v_hdr_flag                            VARCHAR2(5);
              lv_exists                             VARCHAR2(5);

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
              vv_column_name                       VARCHAR2(100);
              gvv_SQLStatement                     VARCHAR2(32000);
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
              g_file_id        UTL_FILE.FILE_TYPE; 
              v_column_name                        XXMX_XFM_TABLE_COLUMNS.COLUMN_NAME%TYPE;
              v_fusion_template_field_name         XXMX_XFM_TABLE_COLUMNS.FUSION_TEMPLATE_FIELD_NAME%TYPE;
              v_data_type                          XXMX_XFM_TABLE_COLUMNS.DATA_TYPE%TYPE;
              v_field_delimiter                    XXMX_XFM_TABLES.FIELD_DELIMITER%TYPE;

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
              csv_filerec csv_fileCol%ROWTYPE; 

              type p_rowid is table of varchar2(1000) index by binary_integer;
              v_rowid                 p_rowid;

              type p_batchname is table of varchar2(1000) index by binary_integer;
              v_batchname                 p_batchname;

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
        BEGIN
            --
            -- ****************************** Initialise Procedure Global Variables ******************************
            --
            gvv_ProgressIndicator := '0010';

            --
            gvv_ReturnStatus  := 'S';
            pv_returnstatus   := 'S';
            --
            -- Delete any MODULE messages FROM previous executions
            -- FOR the Business Entity and Business Entity Level
            --
            xxmx_utilities_pkg.clear_messages
                   (
                    pt_i_ApplicationSuite => vt_Applicationsuite
                   ,pt_i_Application      => vt_Application
                   ,pt_i_BusinessEntity   => pt_i_BusinessEntity 
                   ,pt_i_SubEntity        => pt_i_sub_entity
                   ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages FOR all previous runs are deleted.
                   ,pt_i_Phase            => gct_phase
                   ,pt_i_MessageType      => 'MODULE'
                   ,pv_o_ReturnStatus     => gvv_ReturnStatus
                   );
            --
            IF   gvv_ReturnStatus = 'F'
            THEN
                   --
                   xxmx_utilities_pkg.log_module_message
                        (
                         pt_i_ApplicationSuite  => vt_Applicationsuite
                        ,pt_i_Application       => vt_Application
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity 
                        ,pt_i_SubEntity         => pt_i_sub_entity
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                        ,pt_i_Phase             => gct_phase
                        ,pt_i_Severity          => 'ERROR'
                        ,pt_i_PackageName       => gct_PackageName
                        ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                        ,pt_i_OracleError       => NULL
                        );
                --
                RAISE e_ModuleError;
                --
            END IF;
            --
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
                  ,pt_i_LookupCode    => pt_i_BusinessEntity
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
                        pt_i_BusinessEntity   => pt_i_BusinessEntity
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

             gvv_ProgressIndicator := '0030';

            --
            xxmx_utilities_pkg.log_module_message
                   (
                    pt_i_ApplicationSuite  => vt_Applicationsuite
                   ,pt_i_Application       => vt_Application
                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity 
                   ,pt_i_SubEntity         => pt_i_sub_entity
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase             => gct_phase
                   ,pt_i_Severity          => 'NOTIFICATION'
                   ,pt_i_PackageName       => gct_PackageName
                   ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage     => 'Procedure "'||gct_PackageName||'.'||cv_ProcOrFuncName||'" initiated.',pt_i_OracleError=> NULL
                   );
            --
            --gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
            --
            gvv_ProgressIndicator := '0040';
            --
            xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => vt_Applicationsuite
                                  ,pt_i_Application       => vt_Application
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity 
                                  ,pt_i_SubEntity         => pt_i_sub_entity
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
            gvv_ProgressIndicator := '0050';
            --
            xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => vt_Applicationsuite
                                  ,pt_i_Application       => vt_Application
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                  ,pt_i_SubEntity         => pt_i_sub_entity
                                  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                  ,pt_i_Phase             => gct_phase
                                  ,pt_i_Severity          => 'NOTIFICATION'
                                  ,pt_i_PackageName       => gct_PackageName
                                  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => 'Calling open_hdl '||gvt_MigrationSetName||' File Name '||pt_i_FileName
                                                            ||' ORA File Directory '||vv_file_dir
                                                            ||' vv_file_type       '||vv_file_type
                                  ,pt_i_OracleError       => NULL
                                  );

          For r_file_component in c_file_components(VT_APPLICATIONSUITE ,VT_APPLICATION ) 
          loop

             BEGIN     

                DELETE FROM xxmx_csv_file_temp WHERE  UPPER(file_name) = UPPER(pt_i_FileName);
                commit;
                 --
                -- ****************************** Start generating the csv data file ******************************
                --
                gvv_ProgressIndicator := '0060';
                --
                begin

                       -- DBMS_OUTPUT.PUT_LINE('vt_ApplicationSuite: '||vt_ApplicationSuite);
                       -- DBMS_OUTPUT.PUT_LINE('vt_Application: '||vt_Application);
                       -- DBMS_OUTPUT.PUT_LINE('pt_i_BusinessEntity: '||pt_i_BusinessEntity);
                       -- DBMS_OUTPUT.PUT_LINE('r_file_component.file_group_number: '||r_file_component.file_group_number);
                        --pv_o_OIC_Internal := xxmx_utilities_pkg.get_file_location(vt_ApplicationSuite,vt_Application,pt_i_BusinessEntity,r_file_component.file_group_number,'PLSQL','DATA','OIC_INTERNAL');
                        --pv_o_FTP_Data     := xxmx_utilities_pkg.get_file_location(vt_ApplicationSuite,vt_Application,pt_i_BusinessEntity,r_file_component.file_group_number,'PLSQL','DATA','FTP_DATA');                  
                        --pv_o_FTP_Process  := xxmx_utilities_pkg.get_file_location(vt_ApplicationSuite,vt_Application,pt_i_BusinessEntity,r_file_component.file_group_number,'PLSQL','DATA','FTP_PROCESS');                
                        pv_o_FTP_Out      := xxmx_utilities_pkg.get_file_location(vt_ApplicationSuite,vt_Application,pt_i_BusinessEntity,r_file_component.file_group_number,'OIC','DATA','FTP_OUTPUT');                
                        pv_o_ZIP_Filename := xxmx_utilities_pkg.gen_file_name('ZIP',vt_ApplicationSuite,vt_Application,pt_i_BusinessEntity,r_file_component.file_group_number,'xxmx');                  
                        --pv_o_PROPERTY_Filename := xxmx_utilities_pkg.gen_file_name('PROPERTIES',vt_ApplicationSuite,vt_Application,pt_i_BusinessEntity,r_file_component.file_group_number,'XXX');

                       -- DBMS_OUTPUT.PUT_LINE('pv_o_OIC_Internal: '||pv_o_OIC_Internal);
                       -- DBMS_OUTPUT.PUT_LINE('pv_o_FTP_Data: '||pv_o_FTP_Data);
                       -- DBMS_OUTPUT.PUT_LINE('pv_o_FTP_Process: '||pv_o_FTP_Process);
                       -- DBMS_OUTPUT.PUT_LINE('pv_o_FTP_Out: '||pv_o_FTP_Out);
                       -- DBMS_OUTPUT.PUT_LINE('pv_o_ZIP_Filename: '||pv_o_ZIP_Filename);
                       -- DBMS_OUTPUT.PUT_LINE('pv_o_PROPERTY_Filename: '||pv_o_PROPERTY_Filename);

                exception
                    when others then
                        xxmx_utilities_pkg.log_module_message
                                      (
                                       pt_i_ApplicationSuite  => vt_Applicationsuite
                                      ,pt_i_Application       => vt_Application
                                      ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                      ,pt_i_SubEntity         => pt_i_sub_entity
                                      ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                      ,pt_i_Phase             => gct_phase
                                      ,pt_i_Severity          => 'ERROR'
                                      ,pt_i_PackageName       => gct_PackageName
                                      ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                      ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                      ,pt_i_ModuleMessage     => 'No directory was found in table xxmx_file_locations for APPLICATION:'||vt_Applicationsuite
                                      ,pt_i_OracleError       => NULL
                                      );
                       -- raise e_ModuleError;
                end;
                --


                --
                gvv_ProgressIndicator := '0070';
                gvv_sqlresult_num     := NULL;
                gvv_stop_processing   := NULL;
                --
                -- Check Mandatory Columns in xfm_table
                --

                gvv_sqlstatement :=    'select  Count(1)
                                        from    xxmx_xfm_table_columns xtc, 
                                                xxmx_xfm_tables xt
                                        where    xt.table_name= '''||r_file_component.xfm_table_name
                                        ||''' AND     xtc.xfm_table_id = xt.xfm_table_id
                                            AND     xtc.include_in_outbound_file = ''Y'''
                                     ;
                --DBMS_OUTPUT.PUT_LINE(   gvv_sqlstatement);                              

                OPEN MandColumnData_cur FOR gvv_sqlstatement;
                FETCH MandColumnData_cur INTO gvv_sqlresult_num;

                IF gvv_sqlresult_num = 0 THEN

                   gvv_ProgressIndicator := '0075';
                   gvv_stop_processing := 'Y';
                   gvt_ModuleMessage := 'No Columns are marked for Fusion Outbound File in xxmx_xfm_table_columns';

                    xxmx_utilities_pkg.log_module_message
                     (
                      pt_i_ApplicationSuite  => vt_Applicationsuite
                     ,pt_i_Application       => vt_Application
                     ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                     ,pt_i_SubEntity         => pt_i_sub_entity
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
                END IF;

                Close MandColumnData_cur;
        --
                gvv_ProgressIndicator := '0080';
                gvv_sqlresult_num     := NULL;
                gvv_stop_processing   := NULL;
                --
                -- Check for missing values in the mandatory columns
                --
                FOR r_missing_values 
                IN c_missing_values(r_file_component.xfm_table_name) 
                LOOP

                    gvv_sqlstatement := 'SELECT count(1) from '
                                        ||r_file_component.xfm_table_name
                                        ||' WHERE '
                                        ||r_missing_values.column_name
                                        ||' IS NULL';

                    EXECUTE IMMEDIATE gvv_sqlstatement INTO gvv_sqlresult_num;

                    IF gvv_sqlresult_num > 0 THEN

                            gvv_ProgressIndicator := '0081';
                            gvv_stop_processing := 'Y';
                            gvt_ModuleMessage := 'Column '||r_missing_values.column_name||' is marked as Mandatory with Null values in the XFM table :'||r_file_component.xfm_table_name;
                             xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => vt_Applicationsuite
                              ,pt_i_Application       => vt_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_sub_entity
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
                    END IF;

                END LOOP;

                IF gvv_stop_processing = 'Y' THEN
                    gvt_Severity              := 'ERROR';
                    gvt_ModuleMessage         := 'Extract file has not created. Check xxmx_module_messages for errors.';
                    RAISE e_moduleerror;
                END IF;

                gvv_SQLStatement := NULL;

                BEGIN 
                    Select  'Y'
                    INTO lv_exists
                    from xxmx_dm_subentity_file_map a,
                        xxmx_migration_metadata m,
                        xxmx_xfm_Table_columns b,
                        xxmx_xfm_tables c
                    where a.sub_entity = m.sub_entity
                    and b.xfm_table_id = r_file_component.xfm_table_id
                    and c.table_name = UPPER(m.xfm_table)
                    and b.xfm_table_id = c.xfm_table_id
                    and excel_file_header IS NOT NULL
                    and rownum=1;
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN 
                           lv_exists:= 'N';  

                END;

                --dbms_output.put_line(lv_exists);

                IF( lv_exists = 'Y' )THEN 

                    xxmx_file_col_seq(r_file_component.xfm_table_id,gvv_ReturnStatus);


                    IF( gvv_ReturnStatus <> 'S') THEN

                            gvv_ProgressIndicator := '0081a';
                            gvv_stop_processing := 'Y';
                            gvt_ModuleMessage := 'File SEQ Failed';
                            raise e_ModuleError;
                    END IF;

                    dbms_output.put_line(t_file_col.count);

                    gvv_SQLStatement := NULL;

                    FOR i IN t_file_col.FIRST..t_file_col.LAST
                    LOOP
                    --dbms_output.put_line(t_file_col(i));
                      IF(t_file_col(i) IS NOT NULL) THEN
                        FOR r_file_column 
                        IN c_file_columns(r_file_component.xfm_table_id,t_file_col(i)) 
                        LOOP
                            --dbms_output.put_line(t_file_col(i)||' -- '||r_file_column.column_name||'--'||c_file_columns%rowcount);
                            IF r_file_column.data_type = 'DATE' THEN
                                    vv_column_name := 'to_char('||r_file_column.column_name||',''YYYY/MM/DD'')';
                            ELSIF r_file_column.data_type IN ('VARCHAR2','CHAR') THEN
                                    vv_column_name := '''"''||'||r_file_column.column_name||'||''"''';
                            ELSE
                                    vv_column_name := r_file_column.column_name;
                            END IF;
                             --dbms_output.put_line(t_file_col(i)||' -- '||vv_column_name||'--'||substr(gvv_SQLStatement,1,20));

                            IF( gvv_SQLStatement IS NULL ) THEN 
                                gvv_SQLStatement := 'SELECT '||vv_column_name;
                                vv_hdl_file_header := r_file_column.fusion_template_field_name;
                            ELSE 
                                gvv_SQLStatement := gvv_SQLStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
                                vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;

                            END IF;

                        END LOOP;
                      END IF;-- (t_file_col(i) IS NOT NULL) 
                     END LOOP;
          ELSE 
                    gvv_SQLStatement := NULL;


                    OPEN csv_fileCol(r_file_component.xfm_table_id);
                    LOOP
                    fetch csv_fileCol  into csv_filerec;
                    EXIT WHEN csv_fileCol%NOTFOUND;

                        IF csv_filerec.data_type = 'DATE' THEN
                                vv_column_name := 'to_char('||csv_filerec.column_name||',''YYYY/MM/DD'')';
                        ELSIF csv_filerec.data_type IN ('VARCHAR2','CHAR') THEN
                                vv_column_name := '''"''||'||csv_filerec.column_name||'||''"''';
                        ELSE
                                vv_column_name :=csv_filerec.column_name;
                        END IF;


                        IF( csv_fileCol%rowcount =1) then
                             gvv_SQLStatement := 'SELECT '||vv_column_name;
                             vv_hdl_file_header := csv_filerec.fusion_template_field_name;
                            DBMS_OUTPUT.PUT_LINE(csv_fileCol%rowcount);
                        else
                             gvv_SQLStatement := gvv_SQLStatement||'||'''||csv_filerec.field_delimiter||''''||'||'||vv_column_name;
                             vv_hdl_file_header := vv_hdl_file_header||csv_filerec.field_delimiter||csv_filerec.fusion_template_field_name;
                            DBMS_OUTPUT.PUT_LINE(csv_fileCol%rowcount);
                        END IF ;

                    END LOOP;
                    close csv_fileCol;
            END IF;

                IF(NVL(r_file_component.batch_load,'N') = 'N') THEN

                -- Added new column for batch_value
                gvv_sqlstatement := gvv_sqlstatement||' , '||NVL(r_file_component.seq_in_fbdi_data,'NULL')||' , NULL from '||r_file_component.xfm_table_name
                                    || ' WHERE MIGRATION_SET_ID = '||pt_i_MigrationSetID ;

                ELSE 

                -- Added new column for batch_value
                gvv_sqlstatement := gvv_sqlstatement||' , '||NVL(r_file_component.seq_in_fbdi_data,r_file_component.common_load_column)||', Load_batch  from '||r_file_component.xfm_table_name
                                    || ' WHERE MIGRATION_SET_ID = '||pt_i_MigrationSetID ;

                END IF;
                DBMS_OUTPUT.PUT_LINE(gvv_sqlstatement);
                --
                gvv_ProgressIndicator := '0100';
                --
                    xxmx_utilities_pkg.log_module_message
                          (
                           pt_i_ApplicationSuite  => vt_Applicationsuite
                          ,pt_i_Application       => vt_Application
                          ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                          ,pt_i_SubEntity         => pt_i_sub_entity
                          ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                          ,pt_i_Phase             => gct_phase
                          ,pt_i_Severity          => 'NOTIFICATION'
                          ,pt_i_PackageName       => gct_PackageName
                          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => 'SQL= '||SUBSTR(gvv_SQLStatement,1,3000)
                          ,pt_i_OracleError       => NULL
                          );
                    xxmx_utilities_pkg.log_module_message
                          (
                           pt_i_ApplicationSuite  => vt_Applicationsuite
                          ,pt_i_Application       => vt_Application
                          ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                          ,pt_i_SubEntity         => pt_i_sub_entity
                          ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                          ,pt_i_Phase             => gct_phase
                          ,pt_i_Severity          => 'NOTIFICATION'
                          ,pt_i_PackageName       => gct_PackageName
                          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => SUBSTR('Header='||vv_hdl_file_header,1,3000)
                          ,pt_i_OracleError       => NULL
                          );
                    --
                    gvv_ProgressIndicator := '0105';

                    --
                    --
             insert into xxmx_csv_file_temp 
                            ( file_name, line_type, line_content, status)
                            values 
                            (r_file_component.FUSION_TEMPLATE_NAME,'File Header', vv_hdl_file_header,NULL ); 
                    -- Open cusrsor using the sql in gvv_SQLStatement
                    open r_data for gvv_sqlstatement;
                    LOOP
                    fetch r_data bulk collect into g_extract_data,v_rowid,v_batchname limit     gcn_BulkCollectLimit   ; -- Added new column
                    EXIT WHEN g_extract_data.COUNT=0;

                    --
                    gvv_ProgressIndicator := '0115';
                    xxmx_utilities_pkg.log_module_message
                          (
                           pt_i_ApplicationSuite  => vt_Applicationsuite
                          ,pt_i_Application       => vt_Application
                          ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                          ,pt_i_SubEntity         => pt_i_sub_entity
                          ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                          ,pt_i_Phase             => gct_phase
                          ,pt_i_Severity          => 'NOTIFICATION'
                          ,pt_i_PackageName       => gct_PackageName
                          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => g_extract_data.COUNT
                          ,pt_i_OracleError       => NULL
                          );
                    --

                    if g_extract_data.COUNT = 0 THEN
                        gvv_ProgressIndicator := '0120';
                        gvt_ModuleMessage := 'No data in xfm table to generate the HDL File';
                        raise e_dataerror;
                    END IF;
                    --DBMS_OUTPUT.PUT_LINE('TEST1');
                    --
                    -- Write into data file

                    -- 2. Write the data
                    gvv_ProgressIndicator := '0126';

                     --Added by DG on 20/01/22 for testing
                   IF( pt_file_generated_by = 'OIC') THEN -- Added for Both OIC And PLSQL


                        FORALL i IN 1..g_extract_data.COUNT
                            insert into xxmx_csv_file_temp 
                            ( file_name, line_type, line_content, status,Batch_name,batch_value,business_entity)-- Added new column
                            values 
                            (r_file_component.fusion_template_name,'File Detail', g_extract_data(i),NULL,v_batchname(i),v_rowid(i),pt_i_BusinessEntity ); -- Added new column

                        COMMIT;

                    --Commented by DG on 20/01/22 for testing
                    ELSE  -- Added for Both OIC And PLSQL

                        -- 1. Write the header
                        gvv_ProgressIndicator := '0125';

                        -- Write the Business Entity header
                        xxmx_utilities_pkg.open_csv  ( pt_i_BusinessEntity
                        ,r_file_component.fusion_template_name
                        ,r_file_component.fusion_template_sheet_name
                        ,pv_o_FTP_Out
                        ,'H'
                        ,vv_hdl_file_header
                        ,gvv_ReturnStatus        
                        ,gvt_ReturnMessage);

                        --

                         for i IN 1..g_extract_data.COUNT loop

                            xxmx_utilities_pkg.open_csv  ( pt_i_BusinessEntity
                                                            ,r_file_component.FUSION_TEMPLATE_NAME
                                                            ,r_file_component.fusion_template_sheet_name
                                                            ,pv_o_FTP_Out
                                                            ,'D'
                                                            ,g_extract_data(i)
                                                            ,gvv_ReturnStatus        
                                                            ,gvt_ReturnMessage
                                                            );


                        END LOOP; 
                    END IF;  -- Added for Both OIC And PLSQL
                    g_extract_data.DELETE;
                    END LOOP;
                    close r_data;
                    commit;
                    --
                    -- Close the file handler
                    gvv_ProgressIndicator := '0130';


                    --

             EXCEPTION 
             WHEN e_dataerror THEN

                xxmx_utilities_pkg.log_module_message
                      (
                       pt_i_ApplicationSuite  => vt_Applicationsuite
                      ,pt_i_Application       => vt_Application
                      ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                      ,pt_i_SubEntity         => pt_i_sub_entity
                      ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                      ,pt_i_Phase             => gct_phase
                      ,pt_i_Severity          => 'ERROR'
                      ,pt_i_PackageName       => gct_PackageName
                      ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage     => gvt_ModuleMessage
                      ,pt_i_OracleError       => NULL
                      );
             END;

            --Commented by DG on 20/01/22 for testing
            /* IF( pt_file_generated_by = 'PLSQL') THEN -- Added for Both OIC And PLSQL
                gv_file_Blob:=xxmx_file_zip_utility_pkg.file2blob(pv_o_FTP_Out,r_file_component.FUSION_TEMPLATE_NAME);

                xxmx_file_zip_utility_pkg.add_file( g_zipped_blob, r_file_component.FUSION_TEMPLATE_NAME, gv_file_Blob );
             END IF;*/

          END LOOP;
          /*  IF( pt_file_generated_by = 'PLSQL') THEN -- Added for Both OIC And PLSQL
              xxmx_file_zip_utility_pkg.finish_zip( g_zipped_blob );
              xxmx_file_zip_utility_pkg.save_zip( g_zipped_blob ,pv_o_FTP_Out,pv_o_ZIP_Filename);
            END IF;*/


        --
        EXCEPTION
           WHEN e_nodata THEN 
           --
           ROLLBACK;
           pv_returnstatus := 'F';
           pv_returnmessage := gvt_ReturnMessage;
           xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => vt_Applicationsuite
                        ,pt_i_Application         => vt_Application
                        ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                        ,pt_i_SubEntity           =>  pt_i_sub_entity
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
                    --
              ROLLBACK;
               pv_returnstatus := 'F';
               pv_returnmessage := NVL(gvt_ModuleMessage,gvt_ReturnMessage);


            xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => vt_Applicationsuite
                        ,pt_i_Application         => vt_Application
                        ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                        ,pt_i_SubEntity           =>  pt_i_sub_entity
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                        ,pt_i_Phase               => gct_phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gct_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     
                --
                --RAISE;
                --** END e_ModuleError Exception
                --

            WHEN OTHERS THEN
                --
                ROLLBACK;

                pv_returnstatus := 'F';

                --
                gvt_OracleError := SUBSTR(
                                            SQLERRM
                                        ||'** ERROR_BACKTRACE: '
                                        ||dbms_utility.format_error_backtrace
                                        ,1
                                        ,4000
                                        );
                pv_returnmessage := NVL(gvt_ModuleMessage,gvt_OracleError);
                --
                           xxmx_utilities_pkg.log_module_message(  
                            pt_i_ApplicationSuite    => vt_ApplicationSuite
                           ,pt_i_Application         => vt_Application
                           ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                           ,pt_i_SubEntity           =>  pt_i_sub_entity
                           ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                           ,pt_i_Phase               => gct_phase
                           ,pt_i_Severity            => 'ERROR'
                           ,pt_i_PackageName         => gct_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'Oracle Error'
                           ,pt_i_OracleError         => gvt_OracleError      
                           );     

                --
               -- RAISE;
                -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END generate_csv_file;

    PROCEDURE main
                    (
                     pv_i_application_suite     IN      VARCHAR2
                    ,pt_i_BusinessEntity        IN      xxmx_migration_metadata.business_entity%TYPE DEFAULT NULL
                    ,pt_i_sub_entity            IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
                    ,pt_i_instance_id           IN      VARCHAR2 DEFAULT NULL
					,pt_i_iteration             IN     VARCHAR2 DEFAULT NULL
                    ,pt_i_FileName             IN      xxmx_migration_metadata.data_file_name%TYPE DEFAULT NULL
                   )
    IS 
        CURSOR c_fin_generate_data
        IS
          Select  xt.fusion_template_name file_name,
                    mm.application_suite,
                    mm.application,
                    mm.Business_entity,
                    mm.sub_entity,
                    mm.xfm_Table
            from xxmx_migration_metadata mm, xxmx_xfm_tables xt
            where mm.application_suite = pv_i_application_suite
            and mm.sub_entity = DECODE(NVL(pt_i_sub_entity,'ALL'),'ALL', mm.sub_entity, pt_i_sub_entity)
            AND mm.Business_entity = NvL(pt_i_BusinessEntity,mm.Business_entity)
            and mm.stg_table is not null
            AND mm.enabled_flag = 'Y'
            AND mm.metadata_id = xt.metadata_id;           

        l_migration_set_id xxmx_migration_details.migration_set_id%TYPE := '-1';
        l_sql               VARCHAR2(32000);

        vt_procedure_name   xxmx_migration_metadata.file_gen_procedure_name%TYPE:='main';
        vt_custom_pkg_name  xxmx_migration_metadata.File_Gen_Package%TYPE;
        vt_data_File_name   xxmx_migration_metadata.data_file_name%TYPE;
        vt_application      xxmx_migration_metadata.application%TYPE;
        vt_subentity        xxmx_migration_metadata.sub_entity%TYPE;
        vt_xfm_table        xxmx_migration_metadata.xfm_table%TYPE;
        pv_o_returnstatus     VARCHAR2(200);
        pv_o_returnmessage    VARCHAR2(200);
        vt_iteration        varchar2(50);
        vt_instance_id      varchar2(50); 
        vt_char_pos         number;
        vv_file_dir         xxmx_file_locations.file_location%TYPE;--1.6

        TYPE CoreHCMCurTyp IS REF CURSOR;
        r_core_gen   CoreHCMCurTyp;

  BEGIN
  DBMS_OUTPUT.PUT_LINE('1');

    pv_o_returnstatus := 'S';
    gvv_returnstatus := 'S';

  SELECT directory_path INTO vv_file_dir FROM all_directories 
                         WHERE 
                         directory_name=pt_i_businessentity;--1.6
    IF pv_i_application_suite IN( 'FIN','SCM','PPM')  -- Added for PPM application Suite
    THEN  
    DBMS_OUTPUT.PUT_LINE('2');
      FOR r_generate_data IN c_fin_generate_data
      LOOP      
            IF (pt_i_BusinessEntity IS NULL) 
--             OR (pt_i_sub_entity IS NULL)
             THEN 
               gvt_ModuleMessage:=  'Business Entity  is Mandatory';
             RAISE e_ModuleError;
            END IF;

           l_migration_set_id := NULL;
           l_sql := 'SELECT MAX(migration_Set_id)  FROM '                                            
                      ||r_generate_data.xfm_table;
           EXECUTE IMMEDIATE l_sql INTO l_migration_set_id;

           gvv_ProgressIndicator := '0001';
           xxmx_utilities_pkg.log_module_message
                          (
                           pt_i_ApplicationSuite  => r_generate_data.application_suite
                          ,pt_i_Application       => r_generate_data.application
                          ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                          ,pt_i_SubEntity         => r_generate_data.sub_entity
                          ,pt_i_MigrationSetID    => l_migration_set_id
                          ,pt_i_Phase             => gct_phase
                          ,pt_i_Severity          => 'NOTIFICATION'
                          ,pt_i_PackageName       => gct_PackageName
                          ,pt_i_ProcOrFuncName    => vt_procedure_name
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => 'Before generate_csv_file BusinessEntity:'||pt_i_BusinessEntity||' Subentity: '||r_generate_data.sub_entity 
						    ||'pt_i_instance_id: '||pt_i_instance_id ||' MigrationSet '||l_migration_set_id
                          ,pt_i_OracleError       => NULL
                          );

                  dbms_output.put_line( 'generate_csv_file '||l_migration_set_id);
          IF( l_migration_set_id IS NOT NULL) THEN 
            generate_csv_file
                        (
                         pt_i_MigrationSetID         => l_migration_set_id
                        ,pt_i_FileSetID              => NULL
                        ,pt_i_BusinessEntity         => pt_i_BusinessEntity
                        ,pt_i_FileName               => r_generate_data.file_name
                        ,pt_i_sub_entity             => r_generate_data.sub_entity
                        ,pv_returnstatus             => pv_o_returnstatus
                        ,pv_returnmessage            => pv_o_returnmessage
                       );  
                IF( pv_o_returnstatus <> 'S') THEN 
                    gvt_ModuleMessage:= pv_o_returnmessage;
                    Raise e_ModuleError;
                ELSE 
                    xxmx_utilities_pkg.xxmx_log_oic_status(pt_i_instance_id,NULL,'SUCCESS');

                END IF;
         END IF;           
      END LOOP;
    INSERT INTO xxmx_loadfile_status_log (
                                            load_file_id,
                                            iteration,
                                            filename,
                                            creation_date,
                                            status,
                                            business_entity,
                                            sub_entity,
                                            last_update_date,
                                            r_instance_id,
                                            file_location
                                        ) VALUES (
                                            xxmx_loadfile_status_log_ids_s.NEXTVAL,
                                            pt_i_iteration,
                                            pt_i_filename,
                                            trunc(sysdate),
                                            'R',
                                            pt_i_businessentity,
                                            pt_i_sub_entity,
                                            sysdate,
                                            pt_i_instance_id,  
                                            vv_file_dir
                                            );

     END IF; --pv_i_application_suite IN( 'FIN','SCM')

     IF pv_i_application_suite IN('OLC','PAY', 'HCM'  )
     THEN  
      IF (pt_i_FileName IS NULL)
      THEN 
               gvt_ModuleMessage:= 'File name is Mandatory';
             RAISE e_ModuleError;
      END IF;

     -- DBMS_OUTPUT.PUT_LINE('3');
        /*DBMS_OUTPUT.PUT_LINE(' Select distinct 
                                           mm.file_gen_procedure_name
                                           ,mm.File_Gen_Package
                                           ,case when instr(,'||hdl.data_file_name||',''.dat'',1)=0  then'
                                                ||hdl.data_file_name||'''.dat'''
                                            ||' else'||
                                                hdl.data_file_name||
                                            ' end  vt_data_File_name'
                                           ||',hdl.application
                                           ,''ALL'' sub_entity
                                           ,xfm_table
                                    from xxmx_migration_metadata mm,  xxmx_hcm_datafile_xfm_map hdl
                                    where mm.application_suite = '''||pv_i_application_suite||''''||
                                    ' and mm.Business_entity =  NVL('||''''||pt_i_BusinessEntity||''''||',mm.Business_entity)'||
                                    ' AND mm.enabled_flag = ''Y''
                                      AND mm.file_gen_package is not null '
                                      ||' and hdl.business_entity =  NVL('||''''||pt_i_BusinessEntity||''''||',mm.Business_entity)'||
                                     ' and hdl.sub_entity =NVL('||''''||pt_i_sub_entity||''''||',mm.sub_entity)'
                                     ||' and hdl.sub_entity = mm.sub_entity');*/
        vt_custom_pkg_name := NULL;
        IF( pt_i_sub_entity IS NOT NULL) 
        THEN
        
        OPEN  r_core_gen  FOR ' Select distinct 
                                           mm.file_gen_procedure_name
                                           ,mm.File_Gen_Package
                                           ,mm.data_file_name||''.dat''  vt_data_File_name
                                          ,mm.application
                                           ,''ALL'' sub_entity
                                           ,xfm_table
                                    from xxmx_migration_metadata mm
                                    where mm.application_suite = '''||pv_i_application_suite||''''||
                                    ' and mm.Business_entity =  NVL('||''''||pt_i_BusinessEntity||''''||',mm.Business_entity)'||
                                    ' AND mm.enabled_flag = ''Y''
                                      AND mm.file_gen_package is not null '
                                      ||' and mm.business_entity =  NVL('||''''||pt_i_BusinessEntity||''''||',mm.Business_entity)'||
                                     ' and mm.sub_entity =NVL('||''''||pt_i_sub_entity||''''||',mm.sub_entity)'
                                     ;

        FETCH  r_core_gen INTO  vt_procedure_name   
                               ,vt_custom_pkg_name  
                               ,vt_data_File_name
                               ,vt_application
                               ,vt_subentity
                               ,vt_xfm_table;
        CLOSE r_core_gen;
    
     END IF;
       -- DBMS_OUTPUT.PUT_LINE(vt_custom_pkg_name||' '||vt_procedure_name||' '||vt_application);

        IF( vt_custom_pkg_name IS NOT NULL ) THEN 

       -- DBMS_OUTPUT.PUT_LINE('4 '||vt_xfm_table);

                l_sql := 'SELECT MAX(migration_Set_id)  FROM ' ||vt_xfm_table;

                EXECUTE IMMEDIATE l_sql INTO l_migration_set_id;


                 l_sql        := 'BEGIN '
                                ||vt_SchemaName
                                ||'.'
                                ||vt_custom_pkg_name
                                ||'.'
                                ||vt_procedure_name
                                ||'('
                                ||' pt_i_MigrationSetID  => '
                                ||l_migration_set_id
                                ||',pt_i_BusinessEntity => '''
                                ||pt_i_BusinessEntity
                                ||''''
                                ||',pt_i_SubEntity => '''
                                ||vt_subentity
                                ||''''
                                ||',pt_i_FileName  => '''
                                ||vt_data_File_name
                                ||''''
                                ||' ); END;'
                                ;        

              --  DBMS_OUTPUT.PUT_LINE('4:  sql   : '||l_sql);
                EXECUTE IMMEDIATE l_sql;

        ELSE 


                --   dbms_output.put_line( 'generate_csv_file '||l_migration_set_id);
                 generate_hdl_file
                            (
                             pt_i_MigrationSetID         => NULL
                            ,pt_i_FileSetID              => NULL
                            ,pt_i_BusinessEntity         => pt_i_BusinessEntity
                            ,pt_i_FileName               => pt_i_FileName
                            ,pt_i_sub_entity             => NULL
                            ,pv_returnstatus             => pv_o_returnstatus
                            ,pv_returnmessage            => pv_o_returnmessage
                            );  

                IF( pv_o_returnstatus <> 'S') THEN 
                    gvt_ModuleMessage:= pv_o_returnmessage;
                    Raise e_ModuleError;
                ELSE 
                    xxmx_utilities_pkg.xxmx_log_oic_status(pt_i_instance_id,NULL,'SUCCESS');

                END IF;

        END IF; --IF( vt_custom_pkg_name IS NOT NULL)
INSERT INTO xxmx_loadfile_status_log (
                                            load_file_id,
                                            iteration,
                                            filename,
                                            creation_date,
                                            status,
                                            business_entity,
                                            sub_entity,
                                            last_update_date,
                                            r_instance_id,
                                            file_location
                                        ) VALUES (
                                            xxmx_loadfile_status_log_ids_s.NEXTVAL,
                                            pt_i_iteration,  
                                            pt_i_filename,
                                            trunc(sysdate),
                                            'R',
                                            pt_i_businessentity,
                                            pt_i_sub_entity,
                                            sysdate,
                                            pt_i_instance_id,  
                                            vv_file_dir
                                            );

     END IF; -- IF pv_i_application_suite = 'HCM' 

     EXCEPTION
       WHEN e_ModuleError THEN
                    --
            ROLLBACK;
            gvv_returnstatus := 'F';

               gvv_ProgressIndicator := '0010';

            xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => gvt_Applicationsuite
                        ,pt_i_Application         => gvt_Application
                        ,pt_i_BusinessEntity      => gvt_BusinessEntity
                        ,pt_i_SubEntity           => 'ALL'
                        ,pt_i_MigrationSetID      => 0
                        ,pt_i_Phase               => gct_phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gct_PackageName
                        ,pt_i_ProcOrFuncName      => vt_procedure_name
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                        ,pt_i_OracleError         => NULL
                    );     
                --
            xxmx_utilities_pkg.xxmx_log_oic_status(pt_i_instance_id,gvt_ModuleMessage,'ERROR');
            RAISE;
                --** END e_ModuleError Exception
                --

  END main;

END xxmx_fusion_load_gen_pkg;
/
