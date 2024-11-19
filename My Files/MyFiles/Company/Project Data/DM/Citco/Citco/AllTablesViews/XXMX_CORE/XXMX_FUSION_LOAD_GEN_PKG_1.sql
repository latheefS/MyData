--------------------------------------------------------
--  DDL for Package Body XXMX_FUSION_LOAD_GEN_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_FUSION_LOAD_GEN_PKG" 
	AS
	   /******************************************************************************
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
		 **   1.0  09-Nov-2021  Pallavi             Created for Maximise.
		 **   2.0  26-May-2021  Pallavi             Changed to include new logic for File Generation
		 --   3.0  16/09/2022   Michal Arrowsmith   new procedure clean_xfm_data
		 --   4.0  08/11/2022   Pallavi             Changes to log messages
		 ******************************************************************************
		 */
			gv_file_Blob  blob;
			ct_file_location_type       CONSTANT  xxmx_file_locations.file_location_type%TYPE        := 'FTP_OUTPUT';
			gvt_ApplicationSuite                  xxmx_migration_metadata.application_suite%TYPE    := 'XXMX';
			gvt_Application                       xxmx_migration_metadata.application%TYPE     :='XXMX';
			gct_Phase                             xxmx_module_messages.phase%TYPE              := 'EXPORT';
			gvt_BusinessEntity          CONSTANT  xxmx_migration_metadata.business_entity%TYPE  := 'XXMX_CORE';
			gvt_Sub_Entity              CONSTANT  xxmx_migration_metadata.sub_entity%TYPE  :=      'XXMX_CORE';
			vt_SchemaName                        VARCHAR2(20)                                 := 'XXMX_CORE';
			gct_PackageName             CONSTANT  VARCHAR2(30)                                := 'XXMX_FUSION_LOAD_GEN_PKG';
			gvv_ProgressIndicator                VARCHAR2(100); 


			TYPE t_File_columns IS VARRAY(50000) OF VARCHAR2(200) ;
			t_File_col t_File_columns := t_File_columns();
			gvv_ReturnStatus                     VARCHAR2(1);
			gvv_filter                           VARCHAR2(32000);
			gvt_ReturnMessage                    xxmx_module_messages.module_message%TYPE;
			gvt_ModuleMessage                    xxmx_module_messages.module_message%TYPE;
			gvt_OracleError                      xxmx_module_messages.oracle_error%TYPE;
			e_ModuleError                        EXCEPTION;

procedure produce_agent_csv_file (pt_i_FileName in varchar2,p_fusion_template_sheet_name in varchar2) is
    vv_hdl_file_header                   VARCHAR2(30000);
begin
    vv_hdl_file_header := '"ShortCode","EnterpriseId","ListName","EmailAddress","ActiveFlag","Attribute1","Attribute10","Attribute11","Attribute12","Attribute13","Attribute14","Attribute15","Attribute16","Attribute17","Attribute18","Attribute19","Attribute2","Attribute20","Attribute3","Attribute4","Attribute5","Attribute6","Attribute7","Attribute8","Attribute9","AttributeCategory","AttributeDate1","AttributeDate10","AttributeDate2","AttributeDate3","AttributeDate4","AttributeDate5","AttributeDate6","AttributeDate7","AttributeDate8","AttributeDate9","AttributeNumber1","AttributeNumber10","AttributeNumber2","AttributeNumber3","AttributeNumber4","AttributeNumber5","AttributeNumber6","AttributeNumber7","AttributeNumber8","AttributeNumber9","AttributeTimestamp1","AttributeTimestamp10","AttributeTimestamp2","AttributeTimestamp3","AttributeTimestamp4","AttributeTimestamp5","AttributeTimestamp6","AttributeTimestamp7","AttributeTimestamp8","AttributeTimestamp9","DefaultPrinterName","ReqShortCode","ReqEnterpriseId"';
    insert into xxmx_hdl_file_temp
        ( file_name, line_type, line_content)
		values
		(pt_i_FileName,p_fusion_template_sheet_name, vv_hdl_file_header );
    insert into xxmx_hdl_file_temp
        ( file_name, line_type, line_content)
		select
		pt_i_FileName,p_fusion_template_sheet_name,'"'||bu_code||'","'||enterprise_id||'","'||agent_name||'","'||agent_email_address||'","'||active||'","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","0","","","","","","","","","","","","","",""'
        from xxmx_po_agent;
    commit;
end produce_agent_csv_file;

procedure produce_agent_access_csv_file (pt_i_FileName in varchar2,p_fusion_template_sheet_name in varchar2) is
    vv_hdl_file_header                   VARCHAR2(30000);
begin
    vv_hdl_file_header := '"PO_AGENT.ShortCode","PO_AGENT.EnterpriseId","PO_AGENT.ListName","PO_AGENT.EmailAddress","AccessActionCode","AccessOthersLevelCode","ActiveFlag","AllowedFlag","ReqShortCode","ReqEnterpriseId","EnterpriseId","ShortCode","ListName","EmailAddress"';
    insert into xxmx_hdl_file_temp
        ( file_name, line_type, line_content)
		values
		(pt_i_FileName,p_fusion_template_sheet_name, vv_hdl_file_header );
    commit;
    insert into xxmx_hdl_file_temp
        ( file_name, line_type, line_content)
		select
		pt_i_FileName,p_fusion_template_sheet_name,'"'||bu_code||'","'||enterprise_id||'","'||agent_name||'","'||agent_email_address||'","'||access_action_code||'","'||
        access_action_code_level||'","'||active_flag||'","'||allowed_flag||'","","","'||enterprise_id||'","'||bu_code||'","'||agent_name||'","'||agent_email_address||'"'
        from xxmx_po_agent_access;
    commit;

--"DK5350","1","Yuen, Elvis","elvis.yuen@version1.com","ANALYZE_SPEND","NA","Y","Y","","","1","DK5350","Yuen, Elvis","elvis.yuen@version1.com"

end produce_agent_access_csv_file;


		  FUNCTION XXMX_FILE_PARAMETERS(pt_i_businessentity  xxmx_migration_metadata.business_entity%TYPE
										,pt_i_filename VARCHAR2)
			RETURN VARCHAR2
		  IS
			CURSOR param_count
				IS 
				SELECT parameter_count From xxmx_data_file_parameters 
				where business_entity= pt_i_businessentity
				and fusion_data_file= pt_i_filename ;

				lv_parameters VARCHAR2(5000);
				lv_final_filter VARCHAR(32000);
				lv_sql VARCHAR(32000);
				v_param_count NUMBER;
				cv_ProcOrFuncName                    CONSTANT VARCHAR2(30)                            := 'XXMX_FILE_PARAMETERS';

			BEGIN
				OPEN param_count;
				FETCH param_count INTO v_param_count;
				CLOSE param_count;
				lv_final_filter:= NULL;
				 FOR i IN 1..v_param_count
				 LOOP
					lv_parameters:= NULL;
					lv_sql := 'SELECT parameter_col'||i
							 ||' ||'' = ''||''''''''||  parameter_val'||i
							 ||'||'''''''''
							 ||' from xxmx_data_file_parameters'
							 ||' WHERE BUSINESS_ENTITY = '''|| pt_i_businessentity ||''''
							 ||' AND FUSION_DATA_FILE = '''||pt_i_filename||'''';

							 DBMS_OUTPUT.PUT_LINE(lv_sql);
					EXECUTE Immediate lv_sql INTO lv_parameters; 



					if(i =1)THEN 
					lv_final_filter := lv_final_filter||' WHERE '||lv_parameters;
					ELSE 
					lv_final_filter := lv_final_filter||' and '||lv_parameters;
					END IF ;

					DBMS_OUTPUT.PUT_LINE(lv_final_filter);

				 END LOOP;
				 return lv_final_filter;
			 EXCEPTION
				when OTHERS THEN 
			   --

					 gvt_OracleError := SUBSTR(SQLERRM||'-'||SQLCODE,1,500);
					 xxmx_utilities_pkg.log_module_message(  
							 pt_i_ApplicationSuite    => gvt_ApplicationSuite
							,pt_i_Application         => gvt_Application
							,pt_i_BusinessEntity      => pt_i_BusinessEntity
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

		  PROCEDURE XXMX_FILE_COL_SEQ (p_xfm_Table_id IN VARCHAR2,pv_o_ReturnStatus OUT VARCHAR2)
			IS 

			   cursor c1
			   IS 
			   Select   length(regexp_replace(TRIM(SUBSTR(excel_file_header,1,50000)), '[^,]'))/ length(',') cnt
			   --length(regexp_replace(TRIM(dbms_lob.SUBSTR(excel_file_header,50000)), '[^,]')) / length(',') cnt
					   ,excel_file_header
					   ,b.xfm_table_id
					   ,substr(excel_file_header,INSTR(excel_file_header,',',-1,1)+1,length(excel_file_header)) last_col
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
			   j NUMBER;
			   lv_sql CLOB;
			   cv_ProcOrFuncName                    CONSTANT VARCHAR2(30)                            := 'xxmx_file_col_seq';

			BEGIN 
				gvv_ProgressIndicator:= '0010';
				t_File_col  := t_File_columns();


				FOR r IN C1
				LOOP
					j:=r.cnt+1;
					 t_File_col.EXTEND(r.cnt+1);
					 gvv_ProgressIndicator:= '0015';
					 FOR i IN 1..r.cnt
					 LOOP
						lv_test := NULL;
						gvv_ProgressIndicator:= '0020';
						IF( i=1) THEN 
							gvv_ProgressIndicator:= '0025';
						 -- lv_sql:= 'Select REPLACE(substr('''||r.excel_file_header||''','||i||',INSTR('''||r.excel_file_header||''','','','||i||','||i||')),'','','''')'||
						 --' from dual';
							lv_sql:= 'Select REPLACE(substr(:a,:b,INSTR(:c,'','',:d,:d)),'','','''')'||
									' from dual';
					   -- DBMS_OUTPUT.PUT_LINE(lv_sql);
							EXECUTE IMMEDIATE lv_sql INTO lv_test using r.excel_file_header,i,r.excel_file_header,i,i;
							gvv_ProgressIndicator:= '0030';
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
						   -- DBMS_OUTPUT.PUT_LINE(lv_test);
						ELSE 
							gvv_ProgressIndicator:= '0050'; 
							gvt_ModuleMessage := 'Column with null value';
							--raise e_ModuleError;
						END IF;


					END LOOP;
					gvt_ModuleMessage:= 'Field_name '||r.last_col||' '||j;

					t_File_col(j):= r.last_col;
				   -- DBMS_OUTPUT.PUT_LINE('TEST '||r.last_col||' '||j);
				 END LOOP;

				 gvv_ProgressIndicator:= '0055'; 
				 pv_o_ReturnStatus := 'S';

			   EXCEPTION
			   when e_ModuleError THEN
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

			   when OTHERS THEN 
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

	--
	--
	----------------------------------------------------------
	-- generate_hdl_file For HCM Load
	----------------------------------------------------------
	--
	--

	PROCEDURE generate_hdl_file
				(
				 pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
				,pt_i_FileSetID                  IN      xxmx_migration_headers.File_set_id%TYPE
				,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
				,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
				,pt_file_generated_by            IN      VARCHAR2 DEFAULT 'OIC'
				,pt_i_sub_entity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
			   )
	IS
			  --
			  -- *********************
			  --  CURSOR Declarations
			  -- *********************
              I NUMBER;
              --
				CURSOR c_file_components (p_applicationsuite Varchar2,p_application Varchar2)
				IS
				Select mm.Sub_entity,
					   mm.Metadata_id,
					   mm.business_entity,
					   mm.stg_Table stg_table_name,
					  UPPER( mm.xfm_table) xfm_table_name,
					   xt.xfm_table_id,
					   xt.fusion_template_name,
					   xt.fusion_template_sheet_name
				from xxmx_migration_metadata mm, xxmx_xfm_tables xt
				where mm.application_suite = p_applicationsuite
				and mm.application = p_application
				and mm.Business_entity = pt_i_BusinessEntity
				and mm.sub_entity = DECODE(pt_i_sub_entity,'ALL', mm.sub_entity, pt_i_sub_entity)
				and mm.stg_table is not null
				AND mm.enabled_flag = 'Y'
				AND mm.metadata_id = xt.metadata_id
				AND xt.fusion_template_name = NVL(pt_i_FileName,xt.fusion_template_name)
				;

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

			  cv_ProcOrFuncName           CONSTANT VARCHAR2(30)                                 := 'generate_hdl_file';
			  vt_sub_entity                        xxmx_migration_metadata.sub_entity%TYPE :=pt_i_sub_entity; --4.0
			  gct_phase                   CONSTANT xxmx_module_messages.phase%TYPE       := 'EXPORT';

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
    gvv_ReturnStatus  := '';
	--
	-- Delete any MODULE messages FROM previous executions for the Business Entity and Business Entity Level
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
	--
	if gvv_ReturnStatus = 'F' then
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
						,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
						,pt_i_OracleError       => NULL
				);
				--
			RAISE e_ModuleError;
			--
	end if;
	--
	-- Verify that the value in pt_i_BusinessEntity is valid.
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
	if gvv_ReturnStatus <> 'S' then
				  --
				  gvt_Severity      := 'ERROR';
				  gvt_ModuleMessage := gvt_ReturnMessage;
				  --
				  RAISE e_ModuleError;
				  --
	END IF;
		--
		-- Retrieve the Application Suite and Application for the Business Entity.
		-- A Business Entity can only be defined for a single Application e.g. there
		-- cannot be an "INVOICES" Business Entity in both the "AP" and "AR"
		-- Applications therefore for "AR" the "TRANSACTIONS" Business Entity is used.
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
	if gvv_ReturnStatus <> 'S' THEN
			--
			gvt_Severity      := 'ERROR';
			gvt_ModuleMessage := gvt_ReturnMessage;
			--
			RAISE e_ModuleError;
			--
	END IF; --** IF gvv_ReturnStatus <> 'S'
		--
		--
    gvv_ProgressIndicator := '0030';
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
				   ,pt_i_ModuleMessage     => 'Procedure "'||gct_PackageName||'.'||cv_ProcOrFuncName||'" initiated. File='||pt_i_FileName
                   ,pt_i_OracleError=> NULL
			);
			--
	gvv_ProgressIndicator := '0035';
	gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
		--
	gvv_ProgressIndicator := '0040';
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
	gvv_ProgressIndicator := '0050';
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
				  ,pt_i_ModuleMessage     => 'Calling open_hdl '||gvt_MigrationSetName||' File Name '||pt_i_FileName||' ORA File Directory '||vv_file_dir||' vv_file_type '||vv_file_type
				  ,pt_i_OracleError       => NULL
			);
	--
	-- ****************************** Start generating the HDL data file ******************************
	--
	gvv_ProgressIndicator := '0060';
	begin
			vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
								(vt_Applicationsuite
								,vt_Application
								,pt_i_BusinessEntity
								,ct_file_location_type
								);
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
				   ,pt_i_ModuleMessage     => 'vv_file_dir='||vv_file_dir
				   ,pt_i_OracleError       => NULL
				);
			SELECT file_location
				INTO vv_file_dir
				FROM xxmx_file_locations
				WHERE application_suite = vt_Applicationsuite
				AND application       = vt_Application
				AND business_entity   = pt_i_BusinessEntity
				AND used_by   = 'PLSQL'
				AND file_location_type = ct_file_location_type;
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
				   ,pt_i_ModuleMessage     => 'vv_file_dir='||vv_file_dir
				   ,pt_i_OracleError       => NULL
				);
	exception
			when others then
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
								  ,pt_i_ModuleMessage     => 'No directory was found in table xxmx_file_locations for APPLICATION:'||vt_Applicationsuite
								  ,pt_i_OracleError       => NULL
								  );
	end;
	--
	for r_file_component in c_file_components(VT_APPLICATIONSUITE ,VT_APPLICATION )
	loop
        -- call to update XFM table double quoates trailing spaces etc
		--clean_xfm_data(r_file_component.xfm_table_id,r_file_component.xfm_table_name);
		--
		begin
            DELETE FROM xxmx_hdl_file_temp 
                WHERE  UPPER(file_name) = UPPER(pt_i_FileName)  
				and  UPPER(line_type) = UPPER(r_file_component.fusion_template_sheet_name);
            --
			gvv_ProgressIndicator := '0070';
			gvv_sqlresult_num     := NULL;
			gvv_stop_processing   := NULL;
            -- USERS: For Agent and Agent Access
			--
            if vt_Applicationsuite='HCM' and pt_i_BusinessEntity='USERS' and vt_sub_entity='AGENT' then
                    produce_agent_csv_file(pt_i_FileName,r_file_component.fusion_template_sheet_name);
            elsif vt_Applicationsuite='HCM' and pt_i_BusinessEntity='USERS' and vt_sub_entity='AGENT-ACCESS' then
                    produce_agent_access_csv_file(pt_i_FileName,r_file_component.fusion_template_sheet_name);
            else
			-- Check Mandatory Columns in xfm_table
			--
			gvv_sqlstatement := 'select  Count(1) from xxmx_xfm_table_columns xtc,'||
				'xxmx_xfm_tables xt where xt.table_name= '''||r_file_component.xfm_table_name||
				''' and xtc.xfm_table_id = xt.xfm_table_id and xtc.include_in_outbound_file = ''Y''';
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
            -- MA 15/02/2023 Added this if to bypass the validation for .dat file for HDL. User's .csv files dont need that validation
            if instr(pt_i_FileName,'.dat') > 0  then
                --
                gvv_sqlstatement :=    'select Count(1)
                    from    xxmx_xfm_table_columns xtc, xxmx_xfm_tables xt
                    where   xt.table_name= '''|| r_file_component.xfm_table_name
                                            ||''' AND     xtc.xfm_table_id = xt.xfm_table_id
                                                AND     xtc.include_in_outbound_file = ''Y''' 
                                            ||' AND     Column_name IN('
                                            ||'''METADATA'',
                                              ''OBJECT_NAME'',
                                              ''OBJECTNAME'',
                                              ''SOURCESYSTEMOWNER'',
                                              ''SOURCESYSTEMID'',
                                              ''SOURCE_SYSTEM_OWNER'',
                                              ''SOURCE_SYSTEM_ID'')                                           
											 ' ;  		 
                IF r_file_component.xfm_table_name='XXMX_BANK_BRANCHES_XFM' OR r_file_component.xfm_table_name='XXMX_BANKS_XFM' THEN 
                        I:=1;
                        gvt_ModuleMessage:=gvt_ModuleMessage||'-Value-'||I||'rfile_table_name-->'|| r_file_component.xfm_table_name;
                ELSE
                        I:=0;
                        gvt_ModuleMessage:=gvt_ModuleMessage||'-Value-'||I||'rfile_table_name-->'|| r_file_component.xfm_table_name;
                END IF;
                --
                OPEN MandColumnData_cur FOR gvv_sqlstatement;
                    FETCH MandColumnData_cur INTO gvv_sqlresult_num;--INCLUDED BY VIJAY G TO Exclude Banks and Banks Branches table as the Manndatory columns are only METADATA and OBJECT_NAME.
                    IF gvv_sqlresult_num <4 AND I= 0 THEN
                        gvv_ProgressIndicator := '0085';
                        gvv_stop_processing := 'Y';
                        gvt_ModuleMessage := 'HDL Mandatory Columns are not marked as mandatory like METADATA, SourceSystemID in xxmx_xfm_table_columns ('||gvv_sqlresult_num||')';
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
						 -- raise e_ModuleError;
                    END IF;
                CLOSE MandColumnData_cur;
                --
                -- Check for missing values in the mandatory columns
                FOR r_missing_values IN c_missing_values(r_file_component.xfm_table_name)
                LOOP
                        gvv_sqlstatement := 'SELECT count(1) from '
												||r_file_component.xfm_table_name
												||' WHERE '
												||r_missing_values.column_name
												||' IS NULL';

                        EXECUTE IMMEDIATE gvv_sqlstatement INTO gvv_sqlresult_num;
                        IF gvv_sqlresult_num > 0 THEN
                            gvv_ProgressIndicator := '0080';
                            gvv_stop_processing := 'Y';
                            gvt_ModuleMessage := 'Column '||r_missing_values.column_name||'is marked as Mandatory with Null values in the XFM table :'||r_file_component.xfm_table_name;
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
							-- raise e_ModuleError;
                        END IF;
                END LOOP;
            end if; -- pt_i_FileName like '%.dat'
            --
            IF vv_stop_processing = 'Y' THEN
					gvt_Severity              := 'ERROR';
					gvt_ModuleMessage         := 'Extract file has not created. Check xxmx_module_messages for errors.';
					RAISE e_moduleerror;
            END IF;
            --
            -- Build the SQL for the extract and the header for the output file
            --
            v_hdr_flag           := NULL;
			gvv_sqlstatement     := NULL;
			vv_hdl_file_header   := NULL;
			gvv_sqlstatement     := 'SELECT count(1) from '||r_file_component.xfm_table_name;
            --   
			OPEN MandColumnData_cur FOR gvv_sqlstatement;
            FETCH MandColumnData_cur INTO gvv_sqlresult_num;
            IF( gvv_sqlresult_num <> 0) THEN
                -- Generate HDL Mandatory columns
				-- Adding header to the files and to sql statement
				-- to extract the data from xfm tables
                if instr(pt_i_FileName,'.dat') > 0  then  -- for .dat file
					FOR c_hdl_fusion_common_rec IN c_hdl_fusion_common_cur (r_file_component.xfm_table_id)
					LOOP
						v_hdr_flag              := 'Y';
						gvv_ProgressIndicator   := '0095';
						gvv_stop_processing     := 'Y';
						gvt_ModuleMessage       := 'Adding mandatory Fusion columns to fusion File :'||c_hdl_fusion_common_rec.fusion_template_field_name;
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
					--
                else
                    gvv_SQLStatement    := 'select ';
                    v_hdr_flag          := 'Y';
                end if;
                --
				vv_hdl_file_header := vv_hdl_file_header_mand;
				FOR r_file_column  IN c_file_columns(r_file_component.xfm_table_id)
                LOOP
                    IF( v_hdr_flag is NULL ) THEN
                        gvv_ProgressIndicator   := '0097';
						gvv_stop_processing     := 'Y';
						gvt_ModuleMessage       := 'Mandatory Fusion columns are not added to  fusion File :'||r_file_column.fusion_template_field_name||' v_hdr_flag='||v_hdr_flag;
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
                    END IF;
					IF r_file_column.data_type = 'DATE' THEN
							vv_column_name := 'to_char('||r_file_column.column_name||',''YYYY/MM/DD'')';
					ELSE
							vv_column_name := r_file_column.column_name;
					END IF;
					--
					gvv_ProgressIndicator := '0098';
					CASE c_file_columns%rowcount
						when 1 then
								vv_hdl_file_header := vv_hdl_file_header||'|'||r_file_column.fusion_template_field_name;
								gvv_SQLStatement := gvv_SQLStatement||vv_column_name||'||'''||r_file_column.field_delimiter||'''||';
						else
								gvv_SQLStatement := gvv_SQLStatement||vv_column_name||'||'''||r_file_column.field_delimiter||'''||';
								vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;
					END CASE;
                END LOOP; -- r_file_column
				--
				gvv_SQLStatement:= substr(gvv_SQLStatement,0,LENGTH(gvv_SQLStatement)-7);
				gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name;
                gvv_ProgressIndicator := '0100';
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
									  ,pt_i_ModuleMessage     => SUBSTR('SQL= '||gvv_SQLStatement,1,4000)
									  ,pt_i_OracleError       => NULL
									  );
				--
				gvv_ProgressIndicator := '0101';
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
									  ,pt_i_ModuleMessage     => SUBSTR('Header='||vv_hdl_file_header,1,4000)
									  ,pt_i_OracleError       => NULL
									  );
				--
				--
				-- Open cusrsor using the sql in gvv_SQLStatement
				gvv_ProgressIndicator := '0110';
				open r_data for gvv_sqlstatement;
				fetch r_data bulk collect into g_extract_data;
				close r_data;
				--
				gvv_ProgressIndicator := '0115';
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
									raise e_dataerror;
				END IF;
				--
				-- Write into data file
				-- 1. Write the header
				gvv_ProgressIndicator := '0125';
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
									  ,pt_i_ModuleMessage     => 'pt_file_generated_by='||pt_file_generated_by
									  ,pt_i_OracleError       => NULL
									  );
				if (pt_file_generated_by = 'OIC') THEN -- Added for Both OIC And PLSQL
					gvv_ProgressIndicator := '0126';
					insert into xxmx_hdl_file_temp
								( file_name, line_type, line_content)
							values
								(pt_i_FileName,r_file_component.fusion_template_sheet_name, vv_hdl_file_header );
					FORALL i IN 1..g_extract_data.COUNT
						INSERT INTO xxmx_hdl_file_temp(file_name, line_type, line_content)
						VALUES (pt_i_FileName,r_file_component.fusion_template_sheet_name,g_extract_data(i));
							--Commented by DG on 20/01/22 for testing
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
									  ,pt_i_ModuleMessage     => 'insert into xxmx_hdl_file_temp'
									  ,pt_i_OracleError       => NULL
									  );
					else  -- pt_file_generated_by is not OIC (Added for PLSQL)
						-- Open the extract data file
						xxmx_hdl_utilities_pkg.open_hdl
										('MAXIMISE'
										,pt_i_BusinessEntity
										,pt_i_FileName
										,vv_file_dir
										,vv_file_type
										);
						if g_extract_data.COUNT > 0 THEN
							-- Write the Business Entity header
							xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',r_file_component.fusion_template_sheet_name,vv_hdl_file_header,'M','Y');
						end if;
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
					END IF; -- pt_file_generated_by
				ELSE
					gvv_ProgressIndicator := '0085';
					gvv_stop_processing := 'Y';
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
									  ,pt_i_ModuleMessage     => 'gvv_sqlresult_num is 0'
									  ,pt_i_OracleError       => NULL
									  );
				END IF;  -- IF( gvv_sqlresult_num <> 0)
    end if;
EXCEPTION
				when e_dataerror THEN
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
        END;
    END LOOP;
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
									  ,pt_i_ModuleMessage     => 'generate_hdl_file procedure completed'
									  ,pt_i_OracleError       => NULL
									  );
		--
EXCEPTION
				when e_nodata THEN
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
				when e_ModuleError THEN
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
					RAISE;
					--** END e_ModuleError Exception
					--

				when OTHERS THEN
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

					--
					RAISE;
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
						   mm.file_group_number
					from xxmx_migration_metadata mm, xxmx_xfm_tables xt
					where  mm.metadata_id = xt.metadata_id
					and    mm.application_suite = p_applicationsuite
					and    mm.application = p_application
					and    mm.Business_entity = pt_i_BusinessEntity
					and    mm.sub_entity = DECODE(pt_i_sub_entity,'ALL', mm.sub_entity, pt_i_sub_entity)
					and    mm.stg_table is not null
					AND    mm.enabled_flag = 'Y'
					AND    xt.fusion_template_name = NVL(pt_i_FileName,xt.fusion_template_name);


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
					AND     include_in_outbound_file = 'Y'
					order by xfm_column_seq
					;



				--
				--
				 /************************
				 ** Constant Declarations
				 *************************/
				  --

				  cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                 := 'generate_csv_file';

				  vt_sub_entity                         xxmx_migration_metadata.sub_entity%TYPE :=pt_i_sub_entity ;--'ALL'; changed in 4.0
				  vt_ext                      CONSTANT  VARCHAR2(10)                            := '.csv';
				  gct_phase                   CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXPORT';
				  g_zipped_blob               blob;

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
				  g_file_id                            UTL_FILE.FILE_TYPE;
				  lv_exists                            VARCHAR2(5);
                  v_count                              number;
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
			BEGIN
				--
				-- ****************************** Initialise Procedure Global Variables ******************************
				--
				gvv_ProgressIndicator := '0010';
				--
				gvv_ReturnStatus  := '';
				--
				-- Delete any MODULE messages FROM previous executions
				-- FOR the Business Entity and Business Entity Level
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
				--
				IF   gvv_ReturnStatus = 'F'
				THEN
					   --
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
							,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
							,pt_i_OracleError       => NULL
							);
					--
					RAISE e_ModuleError;
					--
				END IF;
				--
                -- Verify that the value in pt_i_BusinessEntity is valid.
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
					   ,pt_i_SubEntity         => vt_sub_entity
					   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
				gvv_ProgressIndicator := '0040';
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
				gvv_ProgressIndicator := '0050';
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
									  ,pt_i_ModuleMessage     => 'Calling open_hdl '||gvt_MigrationSetName||' File Name '||pt_i_FileName
																||' ORA File Directory '||vv_file_dir
																||' vv_file_type       '||vv_file_type
									  ,pt_i_OracleError       => NULL
									  );

		for r_file_component in c_file_components(VT_APPLICATIONSUITE ,VT_APPLICATION )
		loop
			-- call to update XFM table double quoates trailing spaces etc
			xxmx_utilities_pkg.clean_xfm_data(r_file_component.xfm_table_id,r_file_component.xfm_table_name);
			begin
				DELETE FROM xxmx_csv_file_temp WHERE  UPPER(file_name) = UPPER(pt_i_FileName);
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
										  ,pt_i_SubEntity         => vt_sub_entity
										  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
										  ,pt_i_Phase             => gct_phase
										  ,pt_i_Severity          => 'ERROR'
										  ,pt_i_PackageName       => gct_PackageName
										  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
										  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
										  ,pt_i_ModuleMessage     => 'No directory was found in table xxmx_file_locations for APPLICATION:'||vt_Applicationsuite
										  ,pt_i_OracleError       => NULL
										  );
							raise e_ModuleError;
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
								gvt_ModuleMessage := 'Column '||r_missing_values.column_name||'is marked as Mandatory with Null values in the XFM table :'||r_file_component.xfm_table_name;
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
						END IF;

					END LOOP;

					IF vv_stop_processing = 'Y' THEN
						gvt_Severity              := 'ERROR';
						gvt_ModuleMessage         := 'Extract file has not created. Check xxmx_module_messages for errors.';
						RAISE e_moduleerror;
					END IF;

					gvv_SQLStatement := NULL;

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
						when NO_DATA_FOUND THEN 
							   lv_exists:= 'N';                         
					END;

					IF( lv_exists = 'Y' )THEN 
						 XXMX_FILE_COL_SEQ(r_file_component.xfm_table_id,gvv_ReturnStatus);


						IF( gvv_ReturnStatus <> 'S') THEN

						  gvv_ProgressIndicator := '0081a';
						  gvv_stop_processing := 'Y';
						  gvt_ModuleMessage := 'File SEQ Failed';
						  raise e_ModuleError;
						END IF;

					   -- dbms_output.put_line(t_file_col.count);

					   gvv_SQLStatement := NULL;
						FOR i IN t_file_col.FIRST..t_file_col.LAST
						LOOP

						--dbms_output.put_line(t_file_col(i));

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
								-- dbms_output.put_line(t_file_col(i)||' -- '||vv_column_name||'--'||substr(gvv_SQLStatement,1,20));

								IF( gvv_SQLStatement IS NULL ) THEN 
									gvv_SQLStatement := 'SELECT '||vv_column_name;
									vv_hdl_file_header := r_file_column.fusion_template_field_name;
								ELSE 
									gvv_SQLStatement := gvv_SQLStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
									vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;

								/*ELSIF(r_file_column.column_name IS  NULL) THEN
									gvt_ModuleMessage := 'Please check the Column entry in XFM Tables to generate the File';
									Raise e_moduleerror;
								  */  
								END IF;

							END LOOP;
						 END LOOP;
					ELSE 
						gvv_SQLStatement := NULL;

						FOR r_file_column 
						IN c_file_columns(r_file_component.xfm_table_id,NULL) 
						LOOP
							IF r_file_column.data_type = 'DATE' THEN
									vv_column_name := 'to_char('||r_file_column.column_name||',''YYYY/MM/DD'')';
							ELSIF r_file_column.data_type IN ('VARCHAR2','CHAR') THEN
									vv_column_name := '''"''||'||r_file_column.column_name||'||''"''';
							ELSE
									vv_column_name := r_file_column.column_name;
							END IF;
							CASE c_file_columns%rowcount
								when 1 then
									gvv_SQLStatement := 'SELECT '||vv_column_name;
									vv_hdl_file_header := r_file_column.fusion_template_field_name;
								else
									gvv_SQLStatement := gvv_SQLStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
									vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;
							END CASE;

						END LOOP;
					 END IF;

					/*IF( pt_i_businessentity = 'BALANCES') THEN 
						gvv_filter := xxmx_file_parameters(pt_i_BusinessEntity,pt_i_FileName);
						gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name ||' '||gvv_filter;
					ELSE */
					IF(pt_i_businessentity = 'DAILY_RATES') THEN --MR
					gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name 
											||' WHERE from_conversion_date >= '|| '''01-JAN-2021'''
	                                       ||' AND to_conversion_date <= '|| '''31-DEC-2021''';
					ELSIF(pt_i_businessentity = 'BALANCES' AND pt_i_sub_entity='DETAIL_BAL') THEN --MR
					gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name 
											--||' WHERE period_name = '|| '''Jul-23''';
                                            ||' WHERE period_name IN '|| '(''Apr-23'',''May-23'',''Jun-23'',''Jul-23'',''Aug-23'')';
	--                                        ||' AND to_conversion_date <= '|| '''30-NOV-2021''';
	/* ELSIF(pt_i_businessentity = 'PURCHASE_ORDERS' AND pt_i_sub_entity='PO_HEADERS_STD') THEN --MR
	 gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name 
	 ||' WHERE PRC_BU_NAME IN '|| '(''US1530'')';*/


               /* ELSIF(pt_i_businessentity = 'PURCHASE_ORDERS' AND pt_i_sub_entity='PO_DISTRIBUTIONS_STD') THEN --MR
					gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name 
											||' WHERE PO_HEADER_ID IN  '|| '(                                        
                                            ''1615634'',
''1936631''
)'
;*/
					ELSE

						gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name ;
										   -- ||' WHERE Migration_set_id = '|| pt_i_MigrationSetID;
	--                END IF;--MR*/
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
							  ,pt_i_SubEntity         => vt_sub_entity
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
							  ,pt_i_SubEntity         => vt_sub_entity
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
						-- Open cusrsor using the sql in gvv_SQLStatement
						open r_data for gvv_sqlstatement;
						fetch r_data bulk collect into g_extract_data;
						close r_data;
						--
						gvv_ProgressIndicator := '0115';
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
							  ,pt_i_ModuleMessage     => g_extract_data.COUNT
							  ,pt_i_OracleError       => NULL
							  );
						--
						if g_extract_data.COUNT = 0 THEN
							gvv_ProgressIndicator := '0120';
							gvt_ModuleMessage := 'No data in xfm table to generate the Import File';
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
							  ,pt_i_ModuleMessage     => gvt_ModuleMessage
							  ,pt_i_OracleError       => NULL
							  );
							raise e_dataerror;
						END IF;
						--
						-- Write into data file

						-- 2. Write the data
						gvv_ProgressIndicator := '0126';
    					--Added by DG on 20/01/22 for testing
                        gvt_ModuleMessage := 'pt_file_generated_by='||pt_file_generated_by;
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
							  ,pt_i_ModuleMessage     => gvt_ModuleMessage
							  ,pt_i_OracleError       => NULL
							  );

					    IF( pt_file_generated_by = 'OIC') THEN -- Added for Both OIC And PLSQL


                            insert into xxmx_csv_file_temp
								( file_name, line_type, line_content, status)
								values
								(r_file_component.FUSION_TEMPLATE_NAME,'File Header', vv_hdl_file_header,NULL );
                            select count(*) into v_count from xxmx_csv_file_temp;
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
							  ,pt_i_ModuleMessage     => 'v_count='||v_count
							  ,pt_i_OracleError       => NULL
							  );
							FORALL i IN 1..g_extract_data.COUNT
								insert into xxmx_csv_file_temp
								( file_name, line_type, line_content, status)
								values
								(r_file_component.FUSION_TEMPLATE_NAME,'File Detail', g_extract_data(i),NULL );
                            commit;
						    --Commented by DG on 20/01/22 for testing
                            select count(*) into v_count from xxmx_csv_file_temp;
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
							  ,pt_i_ModuleMessage     => 'v_count='||v_count
							  ,pt_i_OracleError       => NULL
							  );
                        ELSE  -- Added for Both OIC And PLSQL
							-- 1. Write the header
							gvv_ProgressIndicator := '0125';
							-- Write the Business Entity header
							xxmx_utilities_pkg.open_csv  
                                ( 
                                    pt_i_BusinessEntity
                                    ,r_file_component.fusion_template_name
                                    ,r_file_component.fusion_template_sheet_name
                                    ,pv_o_FTP_Out
                                    ,'H'
                                    ,vv_hdl_file_header
                                    ,gvv_ReturnStatus
                                    ,gvt_ReturnMessage
                                );
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
						commit;
						--
						-- Close the file handler
						gvv_ProgressIndicator := '0130';
						--
				 EXCEPTION
				 when e_dataerror THEN

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
            gvt_ModuleMessage := 'Procedure generate_csv_file completed';
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
						  ,pt_i_ModuleMessage     => gvt_ModuleMessage
						  ,pt_i_OracleError       => NULL
						  );


			--
EXCEPTION
			   when e_nodata THEN
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
				when e_ModuleError THEN
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
					RAISE;
					--** END e_ModuleError Exception
					--

				when OTHERS THEN
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

					--
					RAISE;
					-- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
		END generate_csv_file;

PROCEDURE generate_csv_file2
    (
							 pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
							,pt_i_FileSetID                  IN      xxmx_migration_headers.File_set_id%TYPE
							,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
							,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
							,pt_file_generated_by            IN      VARCHAR2 DEFAULT 'OIC'
							,pt_i_sub_entity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
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
						   mm.file_group_number
					from xxmx_migration_metadata mm, xxmx_xfm_tables xt
					where  mm.metadata_id = xt.metadata_id
					and    mm.application_suite = p_applicationsuite
					and    mm.application = p_application
					and    mm.Business_entity = pt_i_BusinessEntity
					and    mm.sub_entity = DECODE(pt_i_sub_entity,'ALL', mm.sub_entity, pt_i_sub_entity)
					and    mm.stg_table is not null
					AND    mm.enabled_flag = 'Y'
					AND    xt.fusion_template_name = NVL(pt_i_FileName,xt.fusion_template_name);


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
					AND     include_in_outbound_file = 'Y'
					order by xfm_column_seq
					;



				--
				--
				 /************************
				 ** Constant Declarations
				 *************************/
				  --

				  cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                 := 'generate_csv_file2';

				  vt_sub_entity                         xxmx_migration_metadata.sub_entity%TYPE :=pt_i_sub_entity ;--'ALL'; changed in 4.0
				  vt_ext                      CONSTANT  VARCHAR2(10)                            := '.csv';
				  gct_phase                   CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXPORT';
				  g_zipped_blob               blob;

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
				  vv_column_name                       VARCHAR2(100);
				  gvv_SQLStatement                     VARCHAR2(32000);
				  gvv_INSStatement                     VARCHAR2(32000);
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
				  g_file_id                            UTL_FILE.FILE_TYPE;
				  lv_exists                            VARCHAR2(5);
                  v_count                              number;
                  v_date_from                          varchar2(30);
                  v_date_to                            varchar2(30);
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
BEGIN
    --
	-- --------------- Initialise Procedure Global Variables ---------------- --
	--
    gvv_ProgressIndicator := '0010';
    gvv_ReturnStatus  := '';
    --
    -- Delete any MODULE messages FROM previous executions
    -- FOR the Business Entity and Business Entity Level
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
				--
    IF gvv_ReturnStatus = 'F' THEN
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
							,pt_i_ModuleMessage     => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
							,pt_i_OracleError       => NULL
							);
					--
					RAISE e_ModuleError;
					--
    END IF;
    --
    -- Verify that the value in pt_i_BusinessEntity is valid.
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
    IF gvv_ReturnStatus <> 'S' THEN
        gvt_Severity      := 'ERROR';
        gvt_ModuleMessage := gvt_ReturnMessage;
        RAISE e_ModuleError;
    END IF;
    --
    -- Retrieve the Application Suite and Application for the Business Entity.
    --
    -- A Business Entity can only be defined for a single Application e.g. there
    -- cannot be an "INVOICES" Business Entity in both the "AP" and "AR"
    -- Applications therefore for "AR" the "TRANSACTIONS" Business Entity is used.
    --
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
    IF gvv_ReturnStatus <> 'S' THEN
        --
        gvt_Severity      := 'ERROR';
        gvt_ModuleMessage := gvt_ReturnMessage;
        --
        RAISE e_ModuleError;
    END IF; --** IF gvv_ReturnStatus <> 'S'
    --
    gvv_ProgressIndicator := '0030';
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
					   ,pt_i_ModuleMessage     => 'Procedure "'||gct_PackageName||'.'||cv_ProcOrFuncName||'" initiated.',pt_i_OracleError=> NULL
					   );
    --
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
    --
    gvv_ProgressIndicator := '0040';
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
    gvv_ProgressIndicator := '0050';
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
									  ,pt_i_ModuleMessage     => 'Calling open_hdl '||gvt_MigrationSetName||' File Name '||pt_i_FileName
																||' ORA File Directory '||vv_file_dir
																||' vv_file_type       '||vv_file_type
									  ,pt_i_OracleError       => NULL
									  );

    --
	-- ------------------------ For each sub-entity ------------------------- --
	--
    for r_file_component in c_file_components(VT_APPLICATIONSUITE ,VT_APPLICATION )
	loop
        --
		-- *) call to update XFM table double quoates trailing spaces etc
        xxmx_utilities_pkg.clean_xfm_data(r_file_component.xfm_table_id,r_file_component.xfm_table_name);
        --
        begin
            --
            delete from xxmx_csv_file_temp WHERE  UPPER(file_name) = UPPER(pt_i_FileName);
            --
            -- *) Check directory
            --
            gvv_ProgressIndicator := '0060';
            --
            begin
                pv_o_FTP_Out      := xxmx_utilities_pkg.get_file_location(vt_ApplicationSuite,vt_Application,pt_i_BusinessEntity,r_file_component.file_group_number,'OIC','DATA','FTP_OUTPUT');
                pv_o_ZIP_Filename := xxmx_utilities_pkg.gen_file_name('ZIP',vt_ApplicationSuite,vt_Application,pt_i_BusinessEntity,r_file_component.file_group_number,'xxmx');
            exception
                when others then
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
										  ,pt_i_ModuleMessage     => 'No directory was found in table xxmx_file_locations for APPLICATION:'||vt_Applicationsuite
										  ,pt_i_OracleError       => NULL
										  );
							raise e_ModuleError;
            end;
            --
            -- *) Check Mandatory Columns in xfm_table
            --
            gvv_ProgressIndicator := '0070';
            gvv_sqlresult_num     := NULL;
            gvv_stop_processing   := NULL;
            gvv_sqlstatement      := 'select count(1) from xxmx_xfm_table_columns xtc,xxmx_xfm_tables xt where xt.table_name='''||r_file_component.xfm_table_name||
                        ''' and xtc.xfm_table_id = xt.xfm_table_id and xtc.include_in_outbound_file = ''Y''';
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
			END IF;
			Close MandColumnData_cur;
            --
            -- *) Check for missing values in the mandatory columns
            --
            gvv_ProgressIndicator := '0080';
            gvv_sqlresult_num     := NULL;
            gvv_stop_processing   := NULL;
            for r_missing_values in c_missing_values(r_file_component.xfm_table_name)
            loop
                gvv_sqlstatement := 'SELECT count(1) from '||r_file_component.xfm_table_name||' WHERE '||r_missing_values.column_name||' IS NULL';
                EXECUTE IMMEDIATE gvv_sqlstatement INTO gvv_sqlresult_num;
                if gvv_sqlresult_num > 0 THEN
								gvv_ProgressIndicator := '0081';
								gvv_stop_processing := 'Y';
								gvt_ModuleMessage := 'Column '||r_missing_values.column_name||'is marked as Mandatory with Null values in the XFM table :'||r_file_component.xfm_table_name;
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
				END IF;
            END LOOP;
            --
            IF vv_stop_processing = 'Y' THEN
						gvt_Severity              := 'ERROR';
						gvt_ModuleMessage         := 'Extract file has not created. Check xxmx_module_messages for errors.';
						RAISE e_moduleerror;
			END IF;
            --
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
						when NO_DATA_FOUND THEN 
							   lv_exists:= 'N';                         
			END;
            --
            IF( lv_exists = 'Y' ) THEN 
                XXMX_FILE_COL_SEQ(r_file_component.xfm_table_id,gvv_ReturnStatus);
                IF( gvv_ReturnStatus <> 'S') THEN
						  gvv_ProgressIndicator := '0081a';
						  gvv_stop_processing := 'Y';
						  gvt_ModuleMessage := 'File SEQ Failed';
						  raise e_ModuleError;
				END IF;
                --
                gvv_SQLStatement := NULL;
                gvv_INSStatement := 'insert into xxmx_csv_file_temp(file_name,line_type,line_content) ';
                FOR i IN t_file_col.FIRST..t_file_col.LAST
                LOOP
                    FOR r_file_column in c_file_columns(r_file_component.xfm_table_id,t_file_col(i)) 
                    LOOP
								IF r_file_column.data_type = 'DATE' THEN
										vv_column_name := 'to_char('||r_file_column.column_name||',''YYYY/MM/DD'')';
								ELSIF r_file_column.data_type IN ('VARCHAR2','CHAR') THEN
										vv_column_name := '''"''||'||r_file_column.column_name||'||''"''';
								ELSE
										vv_column_name := r_file_column.column_name;
								END IF;
								IF( gvv_SQLStatement IS NULL ) THEN 
									gvv_SQLStatement := 'SELECT '||vv_column_name;
                                    gvv_INSStatement := gvv_INSStatement||'select '''||r_file_component.FUSION_TEMPLATE_NAME||''',''File Detail'','||vv_column_name;
									vv_hdl_file_header := r_file_column.fusion_template_field_name;
								ELSE 
									gvv_SQLStatement := gvv_SQLStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
                                    gvv_INSStatement := gvv_INSStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
									vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;
								END IF;

					END LOOP;
                END LOOP;
            ELSE 
                gvv_SQLStatement := NULL;
                FOR r_file_column in c_file_columns(r_file_component.xfm_table_id,NULL) 
                LOOP
							IF r_file_column.data_type = 'DATE' THEN
									vv_column_name := 'to_char('||r_file_column.column_name||',''YYYY/MM/DD'')';
							ELSIF r_file_column.data_type IN ('VARCHAR2','CHAR') THEN
									vv_column_name := '''"''||'||r_file_column.column_name||'||''"''';
							ELSE
									vv_column_name := r_file_column.column_name;
							END IF;
							CASE c_file_columns%rowcount
								when 1 then
									gvv_SQLStatement := 'SELECT '||vv_column_name;
                                    gvv_INSStatement := gvv_INSStatement||'select '''||r_file_component.FUSION_TEMPLATE_NAME||''',''File Detail'','||vv_column_name;
									vv_hdl_file_header := r_file_column.fusion_template_field_name;
								else
									gvv_SQLStatement := gvv_SQLStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
									gvv_INSStatement := gvv_INSStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
									vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;
							END CASE;

                END LOOP;
            END IF;
            --
            -- Remove this if as we will write one file for daily rates and not update the date here. Just leave the else bit
            IF (pt_i_businessentity = 'DAILY_RATES') THEN --MR
                v_date_from := XXMX_UTILITIES_PKG.get_single_parameter_value
                    (
                         pt_i_ApplicationSuite           => 'FIN'
                        ,pt_i_Application                => 'GL'
                        ,pt_i_BusinessEntity             => 'DAILY_RATES'
                        ,pt_i_SubEntity                  => 'ALL'
                        ,pt_i_ParameterCode              => 'LOAD_FILE_DATE_FROM'
                    );
                v_date_to := XXMX_UTILITIES_PKG.get_single_parameter_value
                    (
                         pt_i_ApplicationSuite           => 'FIN'
                        ,pt_i_Application                => 'GL'
                        ,pt_i_BusinessEntity             => 'DAILY_RATES'
                        ,pt_i_SubEntity                  => 'ALL'
                        ,pt_i_ParameterCode              => 'LOAD_FILE_DATE_TO'
                    );
                if v_date_from is null then v_date_from:= '01-JAN-2023'; end if;
               -- if v_date_to   is null then v_date_to  := '31-DEC-2022'; end if;
                gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name 
											||' WHERE from_conversion_date >= '''|| v_date_from;
	                                      -- ||''' AND to_conversion_date <= '|| v_date_to||'''';
				gvv_INSStatement := gvv_INSStatement||' from '||r_file_component.xfm_table_name 
											||' WHERE from_conversion_date >= '''|| v_date_from;
	                                    --    ||''' AND to_conversion_date <= '|| v_date_to||'''';
                gvv_INSStatement:=gvv_INSStatement||' and rowid between :start_id and :end_id';
            else
                gvv_INSStatement:=gvv_INSStatement||' from '||r_file_component.xfm_table_name||' where rowid between :from_id and :to_id';
            END IF;
            --
            gvv_ProgressIndicator := '0100';
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
							  ,pt_i_ModuleMessage     => 'SQL='||SUBSTR(gvv_INSStatement,1,3000)
							  ,pt_i_OracleError       => NULL
							  );
            gvv_ProgressIndicator := '0112';
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
							  ,pt_i_ModuleMessage     => SUBSTR('Header='||vv_hdl_file_header,1,3000)
							  ,pt_i_OracleError       => NULL
							  );
            --
            -- Open cusrsor using the sql in gvv_SQLStatement
            gvv_ProgressIndicator := '0114';
            gvv_sqlstatement := 'SELECT count(1) from '||r_file_component.xfm_table_name;
            execute immediate gvv_sqlstatement into v_count;
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
							  ,pt_i_ModuleMessage     => 'Number of records in table '||r_file_component.xfm_table_name||'='||v_count
							  ,pt_i_OracleError       => NULL
							  );
            --
            if v_count = 0 THEN
                gvv_ProgressIndicator := '0120';
                gvt_ModuleMessage := 'No data in xfm table to generate the Import File';
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
							  ,pt_i_ModuleMessage     => gvt_ModuleMessage
							  ,pt_i_OracleError       => NULL
							  );
                raise e_dataerror;
            end if;
            --
            -- Write into data file
            gvv_ProgressIndicator := '0126';
            gvt_ModuleMessage := 'pt_file_generated_by='||pt_file_generated_by;
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
							  ,pt_i_ModuleMessage     => gvt_ModuleMessage
							  ,pt_i_OracleError       => NULL
							  );
            if pt_file_generated_by = 'OIC'  then -- Added for Both OIC And PLSQL
                insert into xxmx_csv_file_temp
                    ( file_name, line_type, line_content, status)
                    values
                    (r_file_component.FUSION_TEMPLATE_NAME,'File Header', vv_hdl_file_header,NULL );
                select count(*) into v_count from xxmx_csv_file_temp;
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
							  ,pt_i_ModuleMessage     => 'v_count befor insert='||v_count
							  ,pt_i_OracleError       => NULL
							  );
                begin
                    gvt_ModuleMessage:='create_task';
                    dbms_parallel_execute.create_task(task_name=>r_file_component.xfm_table_name);
                    gvt_ModuleMessage:='create_chunks_by_rowid';
                    dbms_parallel_execute.create_chunks_by_rowid(task_name=>r_file_component.xfm_table_name,table_owner=>'XXMX_XFM',table_name=>r_file_component.xfm_table_name,by_row=>TRUE,chunk_size=>10000);
                    gvt_ModuleMessage:='run_task';
                    dbms_parallel_execute.run_task(task_name=>r_file_component.xfm_table_name, sql_stmt=>gvv_INSStatement, language_flag=>DBMS_SQL.NATIVE, parallel_level=>10);
                    gvt_ModuleMessage:='loop';
                    while dbms_parallel_execute.task_status(task_name=>r_file_component.xfm_table_name) not in (dbms_parallel_execute.FINISHED, dbms_parallel_execute.FINISHED_WITH_ERROR)
                    loop
                        null;
                    end loop;
                    gvt_ModuleMessage:='drop_chunks';
                    dbms_parallel_execute.drop_chunks(task_name=>r_file_component.xfm_table_name);
                    gvt_ModuleMessage:='drop_task';
                    dbms_parallel_execute.drop_task(task_name=>r_file_component.xfm_table_name);
                exception
                    when others then
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
							  ,pt_i_ModuleMessage     => gvt_ModuleMessage||sqlerrm
							  ,pt_i_OracleError       => NULL
							  );

                end;
                --
                commit;
                --
                select count(*) into v_count from xxmx_csv_file_temp;
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
							  ,pt_i_ModuleMessage     => 'v_count after insert='||v_count
							  ,pt_i_OracleError       => NULL
							  );
            ELSE  -- Added for Both OIC And PLSQL
							-- 1. Write the header
							gvv_ProgressIndicator := '0125';
							-- Write the Business Entity header
							xxmx_utilities_pkg.open_csv  
                                ( 
                                    pt_i_BusinessEntity
                                    ,r_file_component.fusion_template_name
                                    ,r_file_component.fusion_template_sheet_name
                                    ,pv_o_FTP_Out
                                    ,'H'
                                    ,vv_hdl_file_header
                                    ,gvv_ReturnStatus
                                    ,gvt_ReturnMessage
                                );
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
            commit;
            --
            -- Close the file handler
            gvv_ProgressIndicator := '0130';
			--
        EXCEPTION
				 when e_dataerror THEN
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
		END;
    END LOOP;
    --
    gvt_ModuleMessage := 'Procedure generate_csv_file2 completed';
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
						  ,pt_i_ModuleMessage     => gvt_ModuleMessage
						  ,pt_i_OracleError       => NULL
						  );
			--
EXCEPTION
			   when e_nodata THEN
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
				when e_ModuleError THEN
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
					RAISE;
					--** END e_ModuleError Exception
					--

				when OTHERS THEN
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

					--
					RAISE;
					-- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
END generate_csv_file2;

PROCEDURE main
						(
						 pv_i_application_suite         IN      VARCHAR2
						,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
						,pt_i_sub_entity            IN      xxmx_migration_metadata.sub_entity%TYPE  DEFAULT 'ALL'
					   )
	IS
			CURSOR c_fin_generate_data
			IS
			  Select  xt.fusion_template_name file_name,
						mm.application_suite,
						mm.Business_entity,
						mm.sub_entity,
						mm.xfm_Table,
                        mm.file_gen_package,
                        mm.file_gen_procedure_name
				from xxmx_migration_metadata mm, xxmx_xfm_tables xt
				where mm.application_suite = pv_i_application_suite
				and mm.sub_entity = DECODE(NVL(pt_i_sub_entity,'ALL'),'ALL', mm.sub_entity, pt_i_sub_entity)
				AND mm.Business_entity = NvL(pt_i_BusinessEntity,mm.Business_entity)
				and mm.stg_table is not null
				AND mm.enabled_flag = 'Y'
				AND mm.metadata_id = xt.metadata_id
                order by BUSINESS_ENTITY_SEQ,SUB_ENTITY_SEQ;

			l_migration_set_id xxmx_migration_details.migration_set_id%TYPE := '-1';
			l_sql               VARCHAR2(32000);

			vt_procedure_name   xxmx_migration_metadata.file_gen_procedure_name%TYPE;
			vt_custom_pkg_name  xxmx_migration_metadata.File_Gen_Package%TYPE;
			vt_data_File_name   xxmx_migration_metadata.data_file_name%TYPE;
			vt_application      xxmx_migration_metadata.application%TYPE;
			vt_subentity        xxmx_migration_metadata.sub_entity%TYPE;
			vt_xfm_table        xxmx_migration_metadata.xfm_table%TYPE;

			TYPE CoreHCMCurTyp IS REF CURSOR;
			r_core_gen   CoreHCMCurTyp;
    -- The sschema where packages are installed
    vt_SchemaName                        VARCHAR2(10):= 'XXMX_CORE';

    begin
        if pv_i_application_suite IN( 'FIN','SCM','PPM') THEN
            for r_generate_data IN c_fin_generate_data
            loop
                begin
                    l_sql := 'SELECT MAX(migration_Set_id)  FROM '||r_generate_data.xfm_table;
                    EXECUTE IMMEDIATE l_sql INTO l_migration_set_id;
                exception
                    when others then l_migration_set_id:=0;
                end;
                --
                -- For custom generated csv file
                -- MA 24/2/2023
                if r_generate_data.file_gen_package is not null and r_generate_data.file_gen_procedure_name is not null then
                    l_sql:= 
                        'BEGIN '||vt_SchemaName||'.'||r_generate_data.file_gen_package||'.'||r_generate_data.file_gen_procedure_name||
                        '('||
                        ' pt_i_MigrationSetID  => '||l_migration_set_id||
                        ',pt_i_BusinessEntity => '''||pt_i_BusinessEntity||''''||
                        ',pt_i_SubEntity => '''||pt_i_sub_entity||''''||
                        ',pt_i_FileName  => '''||r_generate_data.file_name||''''||
                        ' ); END;';
                    xxmx_utilities_pkg.log_module_message
                    (
                         pt_i_ApplicationSuite  => pv_i_application_suite
                        ,pt_i_Application       => 'XXMX'
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                        ,pt_i_SubEntity         => pt_i_sub_entity
                        ,pt_i_MigrationSetID    => 0
                        ,pt_i_Phase             => NULL
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_PackageName       => 'xxmx_utilities_pkg'
                        ,pt_i_ProcOrFuncName    => 'call_fusion_load_gen'
                        ,pt_i_ProgressIndicator => '0000'
                        ,pt_i_ModuleMessage     => 'EXECUTE: '||l_sql
                        ,pt_i_OracleError       => NULL
                    );
                    begin
                        execute immediate l_sql;
                    exception
                        when others then
                            raise;
                    end;
                else
                    generate_csv_file
							(
							 pt_i_MigrationSetID         => l_migration_set_id
							,pt_i_FileSetID              => NULL
							,pt_i_BusinessEntity         => pt_i_BusinessEntity
							,pt_i_FileName               => r_generate_data.file_name
							,pt_i_sub_entity             => r_generate_data.sub_entity
						   );
                end if;
            end loop;
        end if;
        --
        xxmx_utilities_pkg.log_module_message
            (
                         pt_i_ApplicationSuite  => pv_i_application_suite
                        ,pt_i_Application       => 'XXMX'
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                        ,pt_i_SubEntity         => pt_i_sub_entity
                        ,pt_i_MigrationSetID    => 0
                        ,pt_i_Phase             => NULL
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_PackageName       => 'xxmx_utilities_pkg'
                        ,pt_i_ProcOrFuncName    => 'call_fusion_load_gen'
                        ,pt_i_ProgressIndicator => '0000'
                        ,pt_i_ModuleMessage     => 'post generate_csv_file'
                        ,pt_i_OracleError       => NULL
            );
        --
        if pv_i_application_suite = 'HCM' THEN
            open r_core_gen for ' Select distinct
											   mm.file_gen_procedure_name
											   ,mm.File_Gen_Package
											   ,case when instr(hdl.data_file_name,''.dat'',1)=0  then
													hdl.data_file_name||''.dat''
												 else
													hdl.data_file_name
												 end  vt_data_File_name
											  ,hdl.application
											   ,''ALL'' sub_entity
											   ,xfm_table
										from xxmx_migration_metadata mm,  xxmx_hcm_datafile_xfm_map hdl
										where mm.application_suite = '''||pv_i_application_suite||''''||
										' and mm.Business_entity =  NVL('||''''||pt_i_BusinessEntity||''''||',mm.Business_entity)'||
										' AND mm.enabled_flag = ''Y''
										  AND mm.file_gen_package is not null '
										  ||' and hdl.business_entity =  NVL('||''''||pt_i_BusinessEntity||''''||',mm.Business_entity)'||
										 ' and hdl.sub_entity =NVL('||''''||pt_i_sub_entity||''''||',mm.sub_entity)'
										 ||' and hdl.sub_entity = mm.sub_entity';

            fetch r_core_gen into  vt_procedure_name
								   ,vt_custom_pkg_name
								   ,vt_data_File_name
								   ,vt_application
								   ,vt_subentity
								   ,vt_xfm_table;
            close r_core_gen;
            if( vt_application = 'HR') then
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
                EXECUTE IMMEDIATE l_sql;
            else
                FOR r_generate_data IN c_fin_generate_data
                LOOP
                    begin
                        l_sql := 'SELECT MAX(migration_Set_id) FROM '||r_generate_data.xfm_table;
                        EXECUTE IMMEDIATE l_sql INTO l_migration_set_id;
                    exception
                        when others then l_migration_set_id:=0;
                    end;
                    xxmx_utilities_pkg.log_module_message
                        (
                                    pt_i_ApplicationSuite  => pv_i_application_suite
                                   ,pt_i_Application       => 'XXMX'
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_sub_entity
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => NULL
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => 'xxmx_utilities_pkg'
                                   ,pt_i_ProcOrFuncName    => 'call_fusion_load_gen'
                                   ,pt_i_ProgressIndicator => '0000'
                                   ,pt_i_ModuleMessage     => 'Call generate_hdl_file. File_name='||r_generate_data.file_name
                                   ,pt_i_OracleError=> NULL
                        );
                    generate_hdl_file
                        (
								 pt_i_MigrationSetID         => l_migration_set_id
								,pt_i_FileSetID              => NULL
								,pt_i_BusinessEntity         => pt_i_BusinessEntity
								,pt_i_FileName               => r_generate_data.file_name
								,pt_i_sub_entity             => r_generate_data.sub_entity
						);
                END LOOP;
            END IF; --IF( vt_application = 'HR')
        END IF; -- IF pv_i_application_suite = 'HCM'
    exception
        when e_ModuleError then
            xxmx_utilities_pkg.log_module_message(  
							 pt_i_ApplicationSuite    => gvt_ApplicationSuite
							,pt_i_Application         => gvt_Application
							,pt_i_BusinessEntity      => gvt_BusinessEntity
							,pt_i_SubEntity           =>  'ALL'
							,pt_i_MigrationSetID      => 0
							,pt_i_Phase               => gct_phase
							,pt_i_Severity            => 'ERROR'
							,pt_i_PackageName         => gct_PackageName
							,pt_i_ProcOrFuncName      => 'main'
							,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							,pt_i_ModuleMessage       => gvt_ModuleMessage  
							,pt_i_OracleError         => gvt_ReturnMessage       );    
        --
        when OTHERS then 
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
							,pt_i_ProcOrFuncName      => 'main'
							,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							,pt_i_ModuleMessage       => gvt_ModuleMessage  
							,pt_i_OracleError         => gvt_OracleError       );    

END main;

PROCEDURE main2
    (
                 pv_i_application_suite         IN      VARCHAR2
                ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                ,pt_i_sub_entity            IN      xxmx_migration_metadata.sub_entity%TYPE  DEFAULT 'ALL'
    )
IS
    CURSOR c_fin_generate_data IS
			  Select  xt.fusion_template_name file_name,
						mm.application_suite,
						mm.Business_entity,
						mm.sub_entity,
						mm.xfm_Table,
                        mm.file_gen_package,
                        mm.file_gen_procedure_name
				from xxmx_migration_metadata mm, xxmx_xfm_tables xt
				where mm.application_suite = pv_i_application_suite
				and mm.sub_entity = DECODE(NVL(pt_i_sub_entity,'ALL'),'ALL', mm.sub_entity, pt_i_sub_entity)
				AND mm.Business_entity = NvL(pt_i_BusinessEntity,mm.Business_entity)
				and mm.stg_table is not null
				AND mm.enabled_flag = 'Y'
				AND mm.metadata_id = xt.metadata_id
                order by BUSINESS_ENTITY_SEQ,SUB_ENTITY_SEQ;

			l_migration_set_id xxmx_migration_details.migration_set_id%TYPE := '-1';
			l_sql               VARCHAR2(32000);

			vt_procedure_name   xxmx_migration_metadata.file_gen_procedure_name%TYPE;
			vt_custom_pkg_name  xxmx_migration_metadata.File_Gen_Package%TYPE;
			vt_data_File_name   xxmx_migration_metadata.data_file_name%TYPE;
			vt_application      xxmx_migration_metadata.application%TYPE;
			vt_subentity        xxmx_migration_metadata.sub_entity%TYPE;
			vt_xfm_table        xxmx_migration_metadata.xfm_table%TYPE;

			TYPE CoreHCMCurTyp IS REF CURSOR;
			r_core_gen   CoreHCMCurTyp;
    -- The sschema where packages are installed
    vt_SchemaName                        VARCHAR2(10):= 'XXMX_CORE';

begin
    if pv_i_application_suite IN( 'FIN','SCM','PPM') THEN
        for r_generate_data IN c_fin_generate_data
        loop
            begin
                l_sql := 'SELECT MAX(migration_Set_id)  FROM '||r_generate_data.xfm_table;
                EXECUTE IMMEDIATE l_sql INTO l_migration_set_id;
            exception
                when others then l_migration_set_id:=0;
            end;
            --
            -- For custom generated csv file
            -- MA 24/2/2023
            if r_generate_data.file_gen_package is not null and r_generate_data.file_gen_procedure_name is not null then
                l_sql:= 
                        'BEGIN '||vt_SchemaName||'.'||r_generate_data.file_gen_package||'.'||r_generate_data.file_gen_procedure_name||
                        '('||
                        ' pt_i_MigrationSetID  => '||l_migration_set_id||
                        ',pt_i_BusinessEntity => '''||pt_i_BusinessEntity||''''||
                        ',pt_i_SubEntity => '''||pt_i_sub_entity||''''||
                        ',pt_i_FileName  => '''||r_generate_data.file_name||''''||
                        ' ); END;';
                xxmx_utilities_pkg.log_module_message
                    (
                         pt_i_ApplicationSuite  => pv_i_application_suite
                        ,pt_i_Application       => 'XXMX'
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                        ,pt_i_SubEntity         => pt_i_sub_entity
                        ,pt_i_MigrationSetID    => 0
                        ,pt_i_Phase             => NULL
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_PackageName       => 'xxmx_utilities_pkg'
                        ,pt_i_ProcOrFuncName    => 'call_fusion_load_gen'
                        ,pt_i_ProgressIndicator => '0000'
                        ,pt_i_ModuleMessage     => 'EXECUTE: '||l_sql
                        ,pt_i_OracleError       => NULL
                    );
                begin
                        execute immediate l_sql;
                    exception
                        when others then
                            raise;
                end;
            else
                generate_csv_file2
                    (
							 pt_i_MigrationSetID         => l_migration_set_id
							,pt_i_FileSetID              => NULL
							,pt_i_BusinessEntity         => pt_i_BusinessEntity
							,pt_i_FileName               => r_generate_data.file_name
							,pt_i_sub_entity             => r_generate_data.sub_entity
					);
            end if;
        end loop;
    end if;
    --
    xxmx_utilities_pkg.log_module_message
            (
                         pt_i_ApplicationSuite  => pv_i_application_suite
                        ,pt_i_Application       => 'XXMX'
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                        ,pt_i_SubEntity         => pt_i_sub_entity
                        ,pt_i_MigrationSetID    => 0
                        ,pt_i_Phase             => NULL
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_PackageName       => 'xxmx_utilities_pkg'
                        ,pt_i_ProcOrFuncName    => 'call_fusion_load_gen'
                        ,pt_i_ProgressIndicator => '0000'
                        ,pt_i_ModuleMessage     => 'post generate_csv_file'
                        ,pt_i_OracleError       => NULL
            );
    --
    if pv_i_application_suite = 'HCM' THEN
            open r_core_gen for ' Select distinct
											   mm.file_gen_procedure_name
											   ,mm.File_Gen_Package
											   ,case when instr(hdl.data_file_name,''.dat'',1)=0  then
													hdl.data_file_name||''.dat''
												 else
													hdl.data_file_name
												 end  vt_data_File_name
											  ,hdl.application
											   ,''ALL'' sub_entity
											   ,xfm_table
										from xxmx_migration_metadata mm,  xxmx_hcm_datafile_xfm_map hdl
										where mm.application_suite = '''||pv_i_application_suite||''''||
										' and mm.Business_entity =  NVL('||''''||pt_i_BusinessEntity||''''||',mm.Business_entity)'||
										' AND mm.enabled_flag = ''Y''
										  AND mm.file_gen_package is not null '
										  ||' and hdl.business_entity =  NVL('||''''||pt_i_BusinessEntity||''''||',mm.Business_entity)'||
										 ' and hdl.sub_entity =NVL('||''''||pt_i_sub_entity||''''||',mm.sub_entity)'
										 ||' and hdl.sub_entity = mm.sub_entity';

            fetch r_core_gen into  vt_procedure_name
								   ,vt_custom_pkg_name
								   ,vt_data_File_name
								   ,vt_application
								   ,vt_subentity
								   ,vt_xfm_table;
            close r_core_gen;
            if( vt_application = 'HR') then
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
                EXECUTE IMMEDIATE l_sql;
    else
                FOR r_generate_data IN c_fin_generate_data
                LOOP
                    begin
                        l_sql := 'SELECT MAX(migration_Set_id) FROM '||r_generate_data.xfm_table;
                        EXECUTE IMMEDIATE l_sql INTO l_migration_set_id;
                    exception
                        when others then l_migration_set_id:=0;
                    end;
                    xxmx_utilities_pkg.log_module_message
                        (
                                    pt_i_ApplicationSuite  => pv_i_application_suite
                                   ,pt_i_Application       => 'XXMX'
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_sub_entity
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => NULL
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => 'xxmx_utilities_pkg'
                                   ,pt_i_ProcOrFuncName    => 'call_fusion_load_gen'
                                   ,pt_i_ProgressIndicator => '0000'
                                   ,pt_i_ModuleMessage     => 'Call generate_hdl_file. File_name='||r_generate_data.file_name
                                   ,pt_i_OracleError=> NULL
                        );
                    generate_hdl_file
                        (
								 pt_i_MigrationSetID         => l_migration_set_id
								,pt_i_FileSetID              => NULL
								,pt_i_BusinessEntity         => pt_i_BusinessEntity
								,pt_i_FileName               => r_generate_data.file_name
								,pt_i_sub_entity             => r_generate_data.sub_entity
						);
                END LOOP;
            END IF; --IF( vt_application = 'HR')
        END IF; -- IF pv_i_application_suite = 'HCM'
    exception
        when e_ModuleError then
            xxmx_utilities_pkg.log_module_message(  
							 pt_i_ApplicationSuite    => gvt_ApplicationSuite
							,pt_i_Application         => gvt_Application
							,pt_i_BusinessEntity      => gvt_BusinessEntity
							,pt_i_SubEntity           =>  'ALL'
							,pt_i_MigrationSetID      => 0
							,pt_i_Phase               => gct_phase
							,pt_i_Severity            => 'ERROR'
							,pt_i_PackageName         => gct_PackageName
							,pt_i_ProcOrFuncName      => 'main'
							,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							,pt_i_ModuleMessage       => gvt_ModuleMessage  
							,pt_i_OracleError         => gvt_ReturnMessage       );    
        --
        when OTHERS then 
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
							,pt_i_ProcOrFuncName      => 'main'
							,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							,pt_i_ModuleMessage       => gvt_ModuleMessage  
							,pt_i_OracleError         => gvt_OracleError       );    

END main2;
END xxmx_fusion_load_gen_pkg;

/
