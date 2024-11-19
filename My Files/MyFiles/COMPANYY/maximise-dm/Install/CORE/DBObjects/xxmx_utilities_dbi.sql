--
--
-- $Header$
--
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT *                                   *
PROMPT * Installation Script Execution Log *
PROMPT *                                   *
PROMPT *************************************
PROMPT
--
SELECT  'Execution Date : '||TO_CHAR(sysdate, 'DD-MON-YYYY')||
        '    '||
        'Execution Time : '||TO_CHAR(sysdate, 'HH24:MI:SS')
FROM    DUAL;
--
--
SELECT 'Installed in Database Instance : '||vdb.name
FROM   v$database  vdb;
--
--
SET HEADING      ON
--
--
COLUMN banner FORMAT A64 HEADING "Version Information"
--
--
SELECT vvsn.banner
FROM   v$version vvsn;
--
--
SET HEADING      OFF
--
--
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
--** FILENAME  : xxmx_utilities_dbi.sql
--**
--** FILEPATH  :
--**
--** VERSION   : $Revision$
--**
--** EXECUTE
--** IN SCHEMA : XXMX_CORE
--**
--** AUTHORS   : Ian S. Vickerstaff
--**
--** PURPOSE   : This script creates the tables, indexes, sequences, grants,
--**             and synonyms to support the following:
--**
--**                  1) Maximise Mapping and Transformation Process
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
--** 1.    [Task Description                                                   ]
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to
--** executing this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                    File Name
--** -------------------------------------------  ------------------------------
--** [File Path]                                  [File Name]
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
--** [File Path]                                  [File Name]
--**
--******************************************************************************
--**
--** DATABASE OBJECTS CREATED
--** ------------------------
--**
--** Schema     Object Name                     Object Type
--** ---------  ------------------------------  --------------------
--**
--******************************************************************************
--**
--** INDEXES CREATED
--** ---------------
--**
--** Schema  Index Name                      Uniqueness
--** ------  ------------------------------  ----------
--** [index_details                                   ]
--**
--**
--******************************************************************************
--**
--** CONSTRAINTS CREATED
--** -------------------
--**
--** Constraint Name                 Deferrable
--** ------------------------------  ----------
--** [constraint_name                         ]
--**
--******************************************************************************
--**
--** GRANTS PERFORMED
--** ----------------
--**
--** S = Select   I = Insert   U = Update   D = Delete   A = All   O = With
--**                                                                   Grant
--**                                                                   Option
--**
--**                                                   Granted
--** S I U D A O  Granted for Schema.Table Name        To
--** - - - - - -  -----------------------------------  -------
--**
--******************************************************************************
--**
--** SYNONYMS CREATED
--** ----------------
--**
--** Synonym Type  Schema    For Schema.Table Name
--** ------------  --------  ------------------------------------
--**
--******************************************************************************
--**
--** TABLE USAGE
--** -----------
--**
--** The tables and views created by this script are used in the following
--** modules:
--**
--** Table Name                      Accessed By Module            Module Type
--** ------------------------------  ----------------------------  -------------
--** [table_name]                    [module_name]                 [module_type]
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
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  09-JUL-2020  Ian S. Vickerstaff  Created.
--**
--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT **************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise Core Functionality
PROMPT **
PROMPT **************************************************************
PROMPT
PROMPT
--
--
PROMPT
PROMPT
PROMPT *********************
PROMPT ** Dropping Sequences
PROMPT *********************
--
--
PROMPT
PROMPT Dropping Sequence xxmx_migration_metadata_ids_s
PROMPT
--
EXEC DropSequence('XXMX_MIGRATION_METADATA_IDS_S')
--
--
PROMPT
PROMPT Dropping Sequence xxmx_module_message_ids_s
PROMPT
--
EXEC DropSequence('XXMX_MODULE_MESSAGE_IDS_S')
--
--
PROMPT
PROMPT Dropping Sequence xxmx_data_message_ids_s
PROMPT
--
EXEC DropSequence('XXMX_DATA_MESSAGE_IDS_S')
--
--
PROMPT
PROMPT Dropping Sequence xxmx_migration_parameter_ids_s
PROMPT
--
EXEC DropSequence('XXMX_MIGRATION_PARAMETER_IDS_S')
--
--
PROMPT
PROMPT Dropping Sequence xxmx_migration_set_ids_s
PROMPT
--
EXEC DropSequence('XXMX_MIGRATION_SET_IDS_S')
--
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Dropping Tables
PROMPT ******************
--
--
PROMPT
PROMPT Dropping Table xxmx_migration_metadata
PROMPT
--
EXEC DropTable ('XXMX_MIGRATION_METADATA')
--
--
PROMPT
PROMPT Dropping Table xxmx_file_group_properties
PROMPT
--
EXEC DropTable ('XXMX_FILE_GROUP_PROPERTIES')
--
--
PROMPT
PROMPT Dropping Table xxmx_file_locations
PROMPT
--
EXEC DropTable ('XXMX_FILE_LOCATIONS')
--
--
PROMPT
PROMPT Dropping Table xxmx_lookup_types
PROMPT
--
EXEC DropTable ('XXMX_LOOKUP_TYPES')
--
--
PROMPT
PROMPT Dropping Table xxmx_lookup_values
PROMPT
--
EXEC DropTable ('XXMX_LOOKUP_VALUES')
--
--
PROMPT
PROMPT Dropping Table xxmx_fusion_job_definitions
PROMPT
--
EXEC DropTable ('XXMX_FUSION_JOB_DEFINITIONS')
--
--
PROMPT
PROMPT Dropping Table xxmx_fusion_job_parameters
PROMPT
--
EXEC DropTable ('XXMX_FUSION_JOB_PARAMETERS')
--
--
PROMPT
PROMPT Dropping Table xxmx_module_messages
PROMPT
--
EXEC DropTable ('XXMX_MODULE_MESSAGES')
--
--
PROMPT
PROMPT Dropping Table xxmx_data_messages
PROMPT
--
EXEC DropTable ('XXMX_DATA_MESSAGES')
--
--
PROMPT
PROMPT Dropping Table xxmx_client_config_parameters
PROMPT
--
EXEC DropTable ('XXMX_CLIENT_CONFIG_PARAMETERS')
--
--
PROMPT
PROMPT Dropping Table xxmx_simple_transforms
PROMPT
--
EXEC DropTable ('XXMX_SIMPLE_TRANSFORMS')
--
--
PROMPT
PROMPT Dropping Table xxmx_migration_parameters
PROMPT
--
EXEC DropTable ('XXMX_MIGRATION_PARAMETERS')
--
--
PROMPT
PROMPT Dropping Table xxmx_source_operating_units
PROMPT
--
EXEC DropTable ('XXMX_SOURCE_OPERATING_UNITS')
--
--
PROMPT
PROMPT Dropping Table xxmx_migration_headers
PROMPT
--
EXEC DropTable ('XXMX_MIGRATION_HEADERS')
--
--
PROMPT
PROMPT Dropping Table xxmx_migration_details
PROMPT
--
EXEC DropTable ('XXMX_MIGRATION_DETAILS')
--
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table xxmx_migration_metadata
PROMPT
--
CREATE TABLE xxmx_migration_metadata
                  (
                   metadata_id                     NUMBER
                  ,application_suite               VARCHAR2(5)      
                  ,application                     VARCHAR2(5)      
                  ,business_entity_seq             NUMBER(3)
                  ,business_entity                 VARCHAR2(100)    
                  ,sub_entity_seq                  NUMBER(3)
                  ,sub_entity                      VARCHAR2(100)   
                  ,entity_package_name             VARCHAR2(30)
                  ,sql_load_name                   VARCHAR2(100)
                  ,stg_procedure_name              VARCHAR2(30)
                  ,stg_table                       VARCHAR2(1000) 
                  ,simple_xfm_performed_by         VARCHAR2(10)
                  ,xfm_procedure_name              VARCHAR2(30)
                  ,xfm_table                       VARCHAR2(1000)
                  ,file_gen_performed_by           VARCHAR2(10)   
                  ,file_gen_package                VARCHAR2(30)   
                  ,file_gen_procedure_name         VARCHAR2(30)
                  ,data_file_name                  VARCHAR2(1000)
                  ,data_file_extension             VARCHAR2(3)
                  ,file_group_number               NUMBER(3)
                  ,enabled_flag                    VARCHAR2(1)
                  ,batch_load                      VARCHAR2(200)  
                  ,seq_in_fbdi_data                VARCHAR2(100) 
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_file_group_properties
PROMPT
--
CREATE TABLE xxmx_file_group_properties
                  (
                   application_suite               VARCHAR2(5)
                  ,application                     VARCHAR2(5)
                  ,business_entity                 VARCHAR2(100)
                  ,file_group_number               NUMBER(3)
                  ,property_file_name_prefix       VARCHAR2(100)
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_file_locations
PROMPT
--
CREATE TABLE xxmx_file_locations
                  (
                   application_suite               VARCHAR2(5)
                  ,application                     VARCHAR2(5)
                  ,business_entity                 VARCHAR2(100)
                  ,file_group_number               NUMBER(3)
                  ,used_by                         VARCHAR2(10)
                  ,file_type                       VARCHAR2(10)
                  ,file_location_type              VARCHAR2(20)
                  ,file_location                   VARCHAR2(2000)
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_lookup_types
PROMPT
--
CREATE TABLE xxmx_lookup_types
                  (
                   application                     VARCHAR2(5)     
                  ,lookup_type                     VARCHAR2(30)   
                  ,customisation_level             VARCHAR2(1)   
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_lookup_values
PROMPT
--
CREATE TABLE xxmx_lookup_values
                  (
                   application                     VARCHAR2(5)  
                  ,lookup_type                     VARCHAR2(30)
                  ,lookup_code                     VARCHAR2(30)
                  ,meaning                         VARCHAR2(80)    
                  ,description                     VARCHAR2(240)
                  ,enabled_flag                    VARCHAR2(1)      
                  ,seeded                          VARCHAR2(1)      
                  ,tag                             VARCHAR2(150)
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_fusion_job_definitions
PROMPT
--
CREATE TABLE xxmx_fusion_job_definitions
                  (
                   application_suite               VARCHAR2(5)      
                  ,application                     VARCHAR2(5)      
                  ,business_entity                 VARCHAR2(100)    
                  ,file_group_number               NUMBER(3)        
                  ,fusion_job_package_name         VARCHAR2(1000)   
                  ,fusion_job_definition_name      VARCHAR2(100)    
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_fusion_job_parameters
PROMPT
--
CREATE TABLE xxmx_fusion_job_parameters
                  (
                   fusion_job_definition_name      VARCHAR2(100)
                  ,parameter_seq                   NUMBER
                  ,parameter_name                  VARCHAR2(1000)   
                  ,parameter_value                 VARCHAR2(100)    
                  ,fusion_mandatory                VARCHAR2(1)
                  ,user_updateable                 VARCHAR2(1)      
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_module_messages
PROMPT
--
CREATE TABLE xxmx_module_messages
                  (
                   module_message_id               NUMBER
                  ,application_suite               VARCHAR2(5)      
                  ,application                     VARCHAR2(5)      
                  ,business_entity                 VARCHAR2(100)    
                  ,sub_entity                      VARCHAR2(100)    
                  ,migration_set_id                NUMBER
                  ,file_set_id                     VARCHAR2(30) 
                  ,phase                           VARCHAR2(20)     
                  ,message_timestamp               TIMESTAMP(3)
                  ,severity                        VARCHAR2(20)    
                  ,package_name                    VARCHAR2(30)
                  ,proc_or_func_name               VARCHAR2(30)
                  ,progress_indicator              VARCHAR2(10)
                  ,module_message                  VARCHAR2(4000)
                  ,oracle_error                    VARCHAR2(4000)
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_data_messages
PROMPT
--
CREATE TABLE xxmx_data_messages
                  (
                   data_message_id                 NUMBER
                  ,application_suite               VARCHAR2(5)      
                  ,application                     VARCHAR2(5)      
                  ,business_entity                 VARCHAR2(100)    
                  ,sub_entity                      VARCHAR2(100)    
                  ,migration_set_id                NUMBER
                  ,phase                           VARCHAR2(20)     
                  ,message_timestamp               TIMESTAMP(3)
                  ,severity                        VARCHAR2(20)     
                  ,data_table                      VARCHAR2(30)     
                  ,record_identifiers              VARCHAR2(4000)   
                  ,data_message                    VARCHAR2(4000)   
                  ,data_elements_and_values        VARCHAR2(4000)   
                  ,row_seq                        NUMBER         
                  ,file_set_id                    VARCHAR2(30)   
                  ,package_name                   VARCHAR2(30)   
                  ,proc_or_func_name              VARCHAR2(30)   
                  );
--
PROMPT
PROMPT Creating Table xxmx_client_config_parameters
PROMPT
--
CREATE TABLE xxmx_client_config_parameters
                  (
                   client_code                     VARCHAR2(10)
                  ,config_parameter                VARCHAR2(100)
                  ,config_value                    VARCHAR2(100)
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_simple_transforms
PROMPT
--
CREATE TABLE xxmx_simple_transforms
                  (
                   application_suite              VARCHAR2(5)     
                  ,application                    VARCHAR2(5)     
                  ,category_code                  VARCHAR2(100)
                  ,source_value                   VARCHAR2(2000)
                  ,fusion_value                   VARCHAR2(2000)
                  ,source_operating_unit_name     VARCHAR2(240)  
                  ,transform_code                 VARCHAR2(100)  
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_migration_parameters
PROMPT
--
CREATE TABLE xxmx_migration_parameters
                  (
                   parameter_id                    NUMBER
                  ,application_suite               VARCHAR2(5)   
                  ,application                     VARCHAR2(5)     
                  ,business_entity                 VARCHAR2(100)   
                  ,sub_entity                      VARCHAR2(100)   
                  ,parameter_code                  VARCHAR2(100)
                  ,parameter_value                 VARCHAR2(2000)
                  ,enabled_flag                    VARCHAR2(1)
                  ,data_source                     VARCHAR2(10)  
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_source_operating_units
PROMPT
--
CREATE TABLE xxmx_source_operating_units
                  (
                    source_operating_unit_name             VARCHAR2(240)  NOT NULL
                   ,fusion_business_unit_name              VARCHAR2(240)  
                   ,fusion_business_unit_id                NUMBER         
                   ,ap_inv_fusion_clearing_acct            VARCHAR2(2000) 
                   ,ar_trx_fusion_clearing_acct            VARCHAR2(2000) 
                   ,lockbox_number                         VARCHAR2(30)   
                   ,lockbox_id                             NUMBER         
                   ,lockbox_transmission_fmt_name          VARCHAR2(100)  
                   ,lockbox_transmission_fmt_id            NUMBER         
                   ,migration_enabled_flag                 VARCHAR2(1)   NOT NULL
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_migration_headers
PROMPT
--
CREATE TABLE xxmx_migration_headers
                  (
                   application_suite               VARCHAR2(5)   
                  ,application                     VARCHAR2(5)    
                  ,business_entity_seq             NUMBER(3)
                  ,business_entity                 VARCHAR2(100)  
                  ,migration_set_id                NUMBER
                  ,file_set_id                     VARCHAR2(30)  
                  ,migration_set_name              VARCHAR2(100)
                  ,phase                           VARCHAR2(20)  
                  ,migration_status                VARCHAR2(20)
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_migration_details
PROMPT
--
CREATE TABLE xxmx_migration_details
                  (
                   application_suite                   VARCHAR2(5)    
                  ,application                         VARCHAR2(5)   
                  ,business_entity_seq                 NUMBER(3)      
                  ,business_entity                     VARCHAR2(100)  
                  ,sub_entity_seq                      NUMBER(3)      
                  ,sub_entity                          VARCHAR2(100)  
                  ,migration_set_id                    NUMBER         
                  ,business_unit_name                  VARCHAR2(240)  
                  ,phase                               VARCHAR2(20)   
                  ,staging_table                       VARCHAR2(30)   
                  ,extract_start_datetime              DATE           
                  ,extract_completion_datetime         DATE           
                  ,extract_row_count                   NUMBER         
                  ,transform_table                     VARCHAR2(30)   
                  ,transform_start_datetime            DATE           
                  ,transform_completion_datetime       DATE           
                  ,export_file_name                    VARCHAR2(2000) 
                  ,export_start_datetime               DATE           
                  ,export_completion_datetime          DATE           
                  ,export_row_count                    NUMBER         
                  ,migration_status                    VARCHAR2(20)   
                  ,file_set_id                         VARCHAR2(30)   
                  ,export_start_timestamp              TIMESTAMP(3)   
                  ,extract_start_timestamp             TIMESTAMP(3)   
                  ,export_seconds                      NUMBER(2)      
                  ,export_minutes                      NUMBER(2)      
                  ,export_hours                        NUMBER(2)      
                  ,export_end_timestamp                TIMESTAMP(3)   
                  ,validate_start_timestamp            TIMESTAMP(3)   
                  ,validate_end_timestamp              TIMESTAMP(3)   
                  ,validate_hours                      NUMBER(2)      
                  ,validate_minutes                    NUMBER(2)      
                  ,validate_seconds                    NUMBER(2)      
                  ,validate_row_count                  NUMBER         
                  ,extract_end_timestamp               TIMESTAMP(3)   
                  ,extract_hours                       NUMBER(2)      
                  ,extract_minutes                     NUMBER(2)      
                  ,extract_seconds                     NUMBER(2)      
                  ,transform_end_timestamp             TIMESTAMP(3)   
                  ,transform_hours                     NUMBER(2)      
                  ,transform_minutes                   NUMBER(2)      
                  ,transform_seconds                   NUMBER(2)      
                  ,transform_start_timestamp           TIMESTAMP(3)
                  ,error_flag                          VARCHAR2(1)
                  );
--
--
--
/*
** XXMX_STG_TABLES
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_stg_tables
PROMPT
--
EXEC DropTable ('XXMX_STG_TABLES')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_stg_tables
PROMPT
--
CREATE TABLE xxmx_core.xxmx_stg_tables
                  (
                    stg_table_id                          NUMBER  NOT NULL       
                   ,metadata_id                           NUMBER   NOT NULL      
                   ,schema_name                            VARCHAR2(128) NOT NULL 
                   ,table_name                            VARCHAR2(128)  NOT NULL 
                   ,comments                              VARCHAR2(2000) 
                   ,sequence_name                         VARCHAR2(30)   
                   ,generate_sequence                     VARCHAR2(1)    
                   ,sequence_start_value                  NUMBER         
                   ,import_data_file_name                 VARCHAR2(240)  
                   ,control_file_name                     VARCHAR2(100)  
                   ,control_file_delimiter                VARCHAR2(1)    
                   ,control_file_optional_quotes          VARCHAR2(1)    
                   ,control_file_script                   CLOB           
                   ,object_creation_script                CLOB           
                   ,column_name1                          VARCHAR2(30)   
                   ,column_name2                          VARCHAR2(30)   
                   ,order_by_clause                       VARCHAR2(150)
                   ,xfm_table_id                          NUMBER         
                   ,purge_flag                            VARCHAR2(1)    
                   ,creation_date                         DATE           
                   ,created_by                            VARCHAR2(240)  
                   ,last_update_date                      DATE           
                   ,last_updated_by                       VARCHAR2(240)                      
                  );
--
PROMPT
PROMPT Creating Index xxmx_stg_tables_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_tables_u1
                 ON xxmx_core.xxmx_stg_tables
                         (
                          stg_table_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_stg_tables_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_tables_u2
                 ON xxmx_core.xxmx_stg_tables
                         (
                          table_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_stg_tables_u3
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_tables_u3
                 ON xxmx_core.xxmx_stg_tables
                         (
                          stg_table_id
                         ,metadata_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_stg_tables_u4
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_tables_u4
                 ON xxmx_core.xxmx_stg_tables
                         (
                          stg_table_id
                         ,table_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_stg_tables_u5
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_tables_u5
                 ON xxmx_core.xxmx_stg_tables
                         (
                          schema_name
                         ,table_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_stg_tables_u6
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_tables_u6
                 ON xxmx_core.xxmx_stg_tables
                         (
                          stg_table_id
                         ,metadata_id
                         ,schema_name
                         ,table_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
/*
** XXMX_STG_TABLE_COLUMNS
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_stg_table_columns
PROMPT
--
EXEC DropTable ('XXMX_STG_TABLE_COLUMNS')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_stg_table_columns
PROMPT
--
CREATE TABLE xxmx_core.xxmx_stg_table_columns
                  (
                     stg_table_id                     NUMBER  NOT NULL       
                    ,stg_table_column_id              NUMBER  NOT NULL      
                    ,stg_column_seq                   NUMBER  NOT NULL       
                    ,cv40_field_name                  VARCHAR2(128)  
                    ,column_name                      VARCHAR2(128)  NOT NULL
                    ,data_type                        VARCHAR2(128)  NOT NULL
                    ,data_length                      NUMBER         
                    ,mandatory                        VARCHAR2(1)    
                    ,enabled_flag                     VARCHAR2(1)    
                    ,comments                         VARCHAR2(2000) 
                    ,include_in_control_file          VARCHAR2(1)    
                    ,ctl_default_value                VARCHAR2(240)  
                    ,ctl_format_string                VARCHAR2(240)  
                    ,ctl_function_name                VARCHAR2(240)  
                    ,lookup_table_name                VARCHAR2(128)  
                    ,lookup_type_name                 VARCHAR2(30)   
                    ,lookup_column1                   VARCHAR2(128)  
                    ,lookup_column2                   VARCHAR2(128)  
                    ,lookup_column3                   VARCHAR2(128)  
                    ,lookup_where_clause              VARCHAR2(2000) 
                    ,validation_sql1                  VARCHAR2(2000) 
                    ,validation_sql2                  VARCHAR2(2000) 
                    ,validation_sql3                  VARCHAR2(2000) 
                    ,xfm_table_id                     NUMBER         
                    ,xfm_table_column_id              NUMBER         
                    ,creation_date                    DATE           
                    ,created_by                       VARCHAR2(240)  
                    ,last_update_date                 DATE           
                    ,last_updated_by                  VARCHAR2(240)  
                  );
--
PROMPT
PROMPT Creating Index xxmx_stg_table_columns_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_table_columns_u1
                 ON xxmx_core.xxmx_stg_table_columns
                         (
                          stg_table_column_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_stg_table_columns_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_table_columns_u2
                 ON xxmx_core.xxmx_stg_table_columns
                         (
                          stg_table_column_id
                         ,stg_table_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
/*--
PROMPT
PROMPT Creating Index xxmx_stg_table_columns_u3
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_table_columns_u3
                 ON xxmx_core.xxmx_stg_table_columns
                         (
                          stg_table_id
                         ,column_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_stg_table_columns_u4
PROMPT
--
CREATE UNIQUE INDEX xxmx_stg_table_columns_u4
                 ON xxmx_core.xxmx_stg_table_columns
                         (
                          stg_table_id
                         ,stg_column_seq
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
     */
--
--
/*
** XXMX_XFM_TABLES
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_xfm_tables
PROMPT
--
EXEC DropTable ('XXMX_XFM_TABLES')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_xfm_tables
PROMPT
--
CREATE TABLE xxmx_core.xxmx_xfm_tables
                  (
                   xfm_table_id                           NUMBER   NOT NULL      
                  ,metadata_id                            NUMBER   NOT NULL       
                  ,schema_name                             VARCHAR2(128) NOT NULL 
                  ,table_name                             VARCHAR2(128) NOT NULL 
                  ,comments                               VARCHAR2(2000) 
                  ,sequence_name                          VARCHAR2(30)   
                  ,generate_sequence                      VARCHAR2(1)    
                  ,sequence_start_value                   NUMBER         
                  ,fusion_template_name                   VARCHAR2(100)  
                  ,fusion_template_sheet_name             VARCHAR2(100)  
                  ,fusion_template_sheet_order            NUMBER         
                  ,field_delimiter                        VARCHAR2(1)    
                  ,include_column_heading                 VARCHAR2(1)    
                  ,include_column_heading_by_row          VARCHAR2(1)    
                  ,purge_flag                             VARCHAR2(1)    
		  ,common_load_column 			  VARCHAR2(300)
                  ,creation_date                          DATE           
                  ,created_by                             VARCHAR2(240)  
                  ,last_update_date                       DATE           
                  ,last_updated_by                        VARCHAR2(240)  
                  );
--
PROMPT
PROMPT Creating Index xxmx_xfm_tables_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_tables_u1
                 ON xxmx_core.xxmx_xfm_tables
                         (
                          xfm_table_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_xfm_tables_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_tables_u2
                 ON xxmx_core.xxmx_xfm_tables
                         (
                          table_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_xfm_tables_u3
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_tables_u3
                 ON xxmx_core.xxmx_xfm_tables
                         (
                          xfm_table_id
                         ,metadata_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_xfm_tables_u4
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_tables_u4
                 ON xxmx_core.xxmx_xfm_tables
                         (
                          xfm_table_id
                         ,table_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_xfm_tables_u5
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_tables_u5
                 ON xxmx_core.xxmx_xfm_tables
                         (
                          schema_name
                         ,table_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_xfm_tables_u6
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_tables_u6
                 ON xxmx_core.xxmx_xfm_tables
                         (
                          xfm_table_id
                         ,metadata_id
                         ,schema_name
                         ,table_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
/*
** XXMX_XFM_TABLE_COLUMNS
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_xfm_table_columns
PROMPT
--
EXEC DropTable ('XXMX_XFM_TABLE_COLUMNS')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_xfm_table_columns
PROMPT
--
CREATE TABLE xxmx_core.xxmx_xfm_table_columns
                  (
                   xfm_table_id                          NUMBER  NOT NULL       
                  ,xfm_table_column_id                   NUMBER  NOT NULL       
                  ,xfm_column_seq                        NUMBER  NOT NULL        
                  ,fusion_template_field_name            VARCHAR2(128)  
                  ,column_name                           VARCHAR2(128) NOT NULL 
                  ,data_type                             VARCHAR2(128) NOT NULL 
                  ,data_length                           NUMBER         
                  ,mandatory                             VARCHAR2(1)    
                  ,comments                              VARCHAR2(2000) 
                  ,creation_date                         DATE           
                  ,created_by                            VARCHAR2(240)  
                  ,last_update_date                      DATE           
                  ,last_updated_by                       VARCHAR2(240)  
                  ,include_in_outbound_file              VARCHAR2(1)    
                  ,enabled_flag                          VARCHAR2(1)    
                  ,user_key_flag                         VARCHAR2(1)    
                  ,transform_code                        VARCHAR2(100)  
                  ,default_value                         VARCHAR2(2000) 
                  ,default_overrides_source_vaL          VARCHAR2(1)    
                  ,default_on_transform_fail             VARCHAR2(1) 
                  );
--
PROMPT
PROMPT Creating Index xxmx_xfm_table_columns_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_table_columns_u1
                 ON xxmx_core.xxmx_xfm_table_columns
                         (
                          xfm_table_column_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_xfm_table_columns_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_table_columns_u2
                 ON xxmx_core.xxmx_xfm_table_columns
                         (
                          xfm_table_column_id
                         ,xfm_table_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_xfm_table_columns_u3
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_table_columns_u3
                 ON xxmx_core.xxmx_xfm_table_columns
                         (
                          xfm_table_id
                         ,column_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_xfm_table_columns_u4
PROMPT
--
CREATE UNIQUE INDEX xxmx_xfm_table_columns_u4
                 ON xxmx_core.xxmx_xfm_table_columns
                         (
                          xfm_table_id
                         ,xfm_column_seq
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
/*
** XXMX_DATA_FILE_PROPERTIES
**
** "xfm_data_key_column" and "xfm_data_key_value" allow multiple
** Data Files to be associated with the same table but the data
** is extracted from the XFM table by specific Data Key Column and
** Value within it.
**
** "file_group_number" will be required for Finance Data Files but
** may not be required for HCM Data files (or perhaps this could be
mandatory 
** and defaulted to 1 for HCM in case they do need to use it).
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_data_file_properties
PROMPT
--
EXEC DropTable ('XXMX_DATA_FILE_PROPERTIES')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_data_file_properties
PROMPT
--
CREATE TABLE xxmx_core.xxmx_data_file_properties
                  (
                   xfm_table_id                    NUMBER           NOT NULL
                  ,xfm_data_key_column             VARCHAR2(128)
                  ,xfm_data_key_value              VARCHAR2(2000)
                  ,generation_sequence             NUMBER           NOT NULL
                  ,file_group_number               NUMBER(3)                   
                  ,data_file_name                  VARCHAR2(1000)   NOT NULL
                  ,data_file_extension             VARCHAR2(3)      NOT NULL
                  ,enabled_flag                    VARCHAR2(1)
                  );
--
PROMPT
PROMPT Creating Index xxmx_data_file_properties_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_data_file_properties_u1
                 ON xxmx_core.xxmx_data_file_properties
                         (
                          xfm_table_id
                         ,generation_sequence
                         ,data_file_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
PROMPT
PROMPT Creating Index xxmx_data_file_properties_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_data_file_properties_u2
                 ON xxmx_core.xxmx_data_file_properties
                         (
                          xfm_table_id
                         ,data_file_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
PROMPT
PROMPT Creating Index xxmx_data_file_properties_u3
PROMPT
--
CREATE UNIQUE INDEX xxmx_data_file_properties_u3
                 ON xxmx_core.xxmx_data_file_properties
                         (
                          generation_sequence
                         ,data_file_name
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
--
--
PROMPT
PROMPT Dropping Sequence xxmx_core.xxmx_stg_table_ids_s
PROMPT
--
EXEC DropSequence('XXMX_STG_TABLE_IDS_S')
--
PROMPT
PROMPT Creating Sequence xxmx_core.xxmx_stg_table_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_core.xxmx_stg_table_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
PROMPT
PROMPT Dropping Sequence xxmx_core.xxmx_stg_table_column_ids_s
PROMPT
--
EXEC DropSequence('XXMX_STG_TABLE_COLUMN_IDS_S')
--
PROMPT
PROMPT Creating Sequence xxmx_core.xxmx_stg_table_column_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_core.xxmx_stg_table_column_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
PROMPT
PROMPT Dropping Sequence xxmx_core.xxmx_xfm_table_ids_s
PROMPT
--
EXEC DropSequence('XXMX_XFM_TABLE_IDS_S')
--
PROMPT
PROMPT Creating Sequence xxmx_core.xxmx_xfm_table_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_core.xxmx_xfm_table_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
PROMPT
PROMPT Dropping Sequence xxmx_core.xxmx_xfm_table_column_ids_s
PROMPT
--
EXEC DropSequence('XXMX_XFM_TABLE_COLUMN_IDS_S')
--
PROMPT
PROMPT Creating Sequence xxmx_core.xxmx_xfm_table_column_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_core.xxmx_xfm_table_column_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
--
PROMPT
PROMPT Dropping Sequence xxmx_core.xxmx_purge_message_ids_s
PROMPT
--
EXEC DropSequence('XXMX_PURGE_MESSAGE_IDS_S')
--
PROMPT
PROMPT Creating Sequence xxmx_core.xxmx_purge_message_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_core.xxmx_purge_message_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
PROMPT
PROMPT Dropping Sequence xxmx_core.xxmx_simple_transform_ids_s
PROMPT
--
EXEC DropSequence('XXMX_SIMPLE_TRANSFORM_IDS_S')
--
PROMPT
PROMPT Creating Sequence xxmx_core.xxmx_simple_transform_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_core.xxmx_simple_transform_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_mapping_definitions
PROMPT
--
EXEC DropTable ('XXMX_MAPPING_DEFINITIONS')
--
PROMPT
PROMPT Creating table xxmx_mapping_definitions
PROMPT
--


CREATE TABLE xxmx_core.xxmx_mapping_definitions
            (
                mapping_id                          NUMBER    NOT NULL     
               ,appl_name                           VARCHAR2(30) NOT NULL  
               ,mapping_name                        VARCHAR2(150) NOT NULL 
               ,seq_no                              NUMBER         
               ,source_org_id                       NUMBER         
               ,source_object_id                    NUMBER         
               ,source_object_name                  VARCHAR2(150)  
               ,source_column_name                  VARCHAR2(150)  
               ,source_value                        VARCHAR2(250)  
               ,source_id                           VARCHAR2(30)   
               ,target_org_id                       NUMBER         
               ,target_object_id                    NUMBER         
               ,target_object_name                  VARCHAR2(150)  
               ,target_column_name                  VARCHAR2(150)  
               ,target_object_where_clause          VARCHAR2(1000) 
               ,mapping_type                        VARCHAR2(30)   
               ,mapping_defination                  VARCHAR2(1000) 
               ,target_value                        VARCHAR2(250)  
               ,target_id                           VARCHAR2(30)   
               ,comments                            VARCHAR2(500)  
               ,enabled_flag                        VARCHAR2(1)   NOT NULL 
               ,creation_date                       DATE           
               ,created_by                          NUMBER         
               ,last_update_date                    DATE           
               ,last_updated_by                     NUMBER  
            );

--
--
/*
** XXMX_PURGE_MESSAGES
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_purge_messages
PROMPT
--
EXEC DropTable ('XXMX_PURGE_MESSAGES')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_purge_messages
PROMPT
--
CREATE TABLE xxmx_core.xxmx_purge_messages
                  (
                   purge_message_id                NUMBER           NOT NULL
                  ,application_suite               VARCHAR2(5)      NOT NULL  
                  ,application                     VARCHAR2(5)      NOT NULL   
                  ,business_entity                 VARCHAR2(30)     NOT NULL   
                  ,sub_entity                      VARCHAR2(60)     NOT NULL  
                  ,migration_set_id                NUMBER           
                  ,file_set_id                     VARCHAR2(30) 
                  ,message_timestamp               TIMESTAMP(3)     NOT NULL
                  ,severity                        VARCHAR2(20)     NOT NULL  
                  ,progress_indicator              VARCHAR2(10)
                  ,purge_message                   VARCHAR2(4000)
                  ,oracle_error                    VARCHAR2(4000)
                  );
--
PROMPT
PROMPT Creating Index xxmx_purge_messages_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_purge_messages_u1
                 ON xxmx_core.xxmx_purge_messages
                         (
                          purge_message_id 
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
/*
** XXMX_CORE_PARAMETERS
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_core_parameters
PROMPT
--
EXEC DropTable ('XXMX_CORE_PARAMETERS')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_core_parameters
PROMPT
--
CREATE TABLE xxmx_core.xxmx_core_parameters
                  (
                   core_parameter_id               NUMBER           NOT NULL
                  ,parameter_code                  VARCHAR2(100)
                  ,lookup_type                     VARCHAR2(30)
                  ,parameter_value                 VARCHAR2(2000)
		  ,Enabled_flag			   VARCHAR2(1)
                  );
--
PROMPT
PROMPT Creating Index xxmx_core_parameters_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_core_parameters_u1
                 ON xxmx_core.xxmx_core_parameters
                         (
                          core_parameter_id 
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );

--
--
--
--
PROMPT
PROMPT Dropping Sequence xxmx_core.xxmx_core_parameter_ids_s
PROMPT
--
EXEC DropSequence('XXMX_CORE_PARAMETER_IDS_S')
--
PROMPT
PROMPT Creating Sequence xxmx_core.xxmx_core_parameter_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_core.xxmx_core_parameter_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
--
--
PROMPT
PROMPT
PROMPT *******************
PROMPT ** Creating table xxmx_hcm_comp_ssid_transform
PROMPT *******************
--
--
EXEC DropTable ('XXMX_HCM_COMP_SSID_TRANSFORM')
--
--
--
CREATE TABLE xxmx_core.xxmx_hcm_comp_ssid_transform
                        (	application                VARCHAR2(5 BYTE)
                           ,xfm_table                 VARCHAR2(1000 BYTE)
                           ,transform_code            VARCHAR2(3000 BYTE)
                           ,Column_name               VARCHAR2(150)
                        );
--
--
PROMPT
PROMPT
PROMPT *******************
PROMPT ** Creating table xxmx_xfm_update_columns
PROMPT *******************
--
EXEC DropTable ('XXMX_XFM_UPDATE_COLUMNS')
--
CREATE TABLE xxmx_core.xxmx_xfm_update_columns
                           (
                               mandatory                        VARCHAR2(20)  
                              ,include_in_outbound_file         VARCHAR2(20)  
                              ,column_name                      VARCHAR2(128) 
                              ,table_name                       VARCHAR2(200) 
                              ,fusion_template_field_name       VARCHAR2(150) 
                              ,fusion_template_sheet_name       VARCHAR2(150) 
                              ,user_key                         VARCHAR2(1)   
                              ,appl_name                        VARCHAR2(30) 
                              ,transform_code                   VARCHAR2(300)
                              ,default_value                    VARCHAR2(200)
                           );
--
--
--
--
Create or replace PUBLIC synonym XXMX_XFM_UPDATE_COLUMNS FOR XXMX_CORE.XXMX_XFM_UPDATE_COLUMNS;

PROMPT
PROMPT
PROMPT *******************
PROMPT ** Creating table xxmx_stg_update_columns
PROMPT *******************
--
EXEC DropTable ('XXMX_STG_UPDATE_COLUMNS')
--
CREATE TABLE xxmx_core.xxmx_stg_update_columns
                              (
                                  mandatory                     VARCHAR2(20)  
                                 ,include_in_control_file       VARCHAR2(20)  
                                 ,column_name                   VARCHAR2(128) 
                                 ,table_name                    VARCHAR2(200) 
                                 ,appl_name                     VARCHAR2(30)
                              );
--
--
PROMPT
PROMPT
PROMPT *******************
PROMPT ** Creating Indexes
PROMPT *******************
--
--
--PROMPT
--PROMPT Creating Index [index_name]
--PROMPT
----
--CREATE INDEX [index_name]
--          ON [table_name]
--                  (
--                   [column_list]
--                  )
--TABLESPACE [tablespace_name]
--PCTFREE    10
--INITRANS   2
--MAXTRANS   255
--STORAGE
--     (
--      INITIAL     [xxK or xxM]
--      NEXT        [xxK or xxM]
--      MINEXTENTS  1
--      MAXEXTENTS  505
--      PCTINCREASE 0
--     );
--
PROMPT
PROMPT Creating Index xxmx_migration_metadata_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_migration_metadata_u1
                 ON xxmx_migration_metadata
                         (
                          metadata_id
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
PROMPT
PROMPT Creating Index xxmx_migration_metadata_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_migration_metadata_u2
                 ON xxmx_migration_metadata
                         (
                          business_entity_seq
                         ,business_entity
                         ,sub_entity_seq
                         ,sub_entity
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_migration_metadata_n1
PROMPT
--
CREATE INDEX xxmx_migration_metadata_n1
          ON xxmx_migration_metadata
                  (
                   business_entity_seq
                  ,business_entity
                  )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
PROMPT
PROMPT Creating Index xxmx_simple_transforms_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_simple_transforms_u1
                 ON xxmx_simple_transforms
                         (
                          application_suite
                         ,application
                         ,category_code
                         ,source_value
                         ,fusion_value
                         )
--TABLESPACE [tablespace_name]
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
PROMPT
PROMPT
PROMPT *********************
PROMPT ** Creating Sequences
PROMPT *********************
--
--
PROMPT
PROMPT Creating Sequence xxmx_migration_metadata_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_migration_metadata_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
PROMPT
PROMPT Creating Sequence xxmx_module_message_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_module_message_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
PROMPT
PROMPT Creating Sequence xxmx_data_message_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_data_message_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
PROMPT
PROMPT Creating Sequence xxmx_migration_parameter_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_migration_parameter_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
PROMPT
PROMPT Creating Sequence xxmx_migration_set_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_migration_set_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
--
--
GRANT ALL on XXMX_CORE.XXMX_XFM_UPDATE_COLUMNS TO XXMX_XFM;
GRANT ALL on XXMX_CORE.XXMX_STG_UPDATE_COLUMNS TO XXMX_STG;

GRANT ALL ON XXMX_CORE.xxmx_migration_metadata to XXMX_XFM;
GRANT ALL ON XXMX_CORE.xxmx_migration_metadata to XXMX_STG;
GRANT ALL ON XXMX_CORE.xxmx_stg_table_column_ids_s to XXMX_STG;
GRANT ALL ON XXMX_CORE.xxmx_xfm_table_column_ids_s to XXMX_XFM;
GRANT ALL ON XXMX_CORE.xxmx_xfm_table_ids_s to XXMX_XFM;
GRANT ALL ON XXMX_CORE.xxmx_stg_table_ids_s to XXMX_STG;
GRANT ALL ON XXMX_CORE.xxmx_stg_tables to XXMX_STG;
GRANT ALL ON XXMX_CORE.xxmx_stg_table_columns to XXMX_STG;
GRANT ALL ON XXMX_CORE.xxmx_xfm_tables to XXMX_XFM;
GRANT ALL ON XXMX_CORE.xxmx_xfm_table_columns to XXMX_XFM;
GRANT ALL ON XXMX_CORE.xxmx_stg_tables to XXMX_XFM;
GRANT ALL ON XXMX_CORE.xxmx_stg_table_columns to XXMX_XFM;
GRANT ALL ON XXMX_CORE.xxmx_xfm_tables to XXMX_STG;
GRANT ALL ON XXMX_CORE.xxmx_xfm_table_columns to XXMX_STG;


--
/*
** XXMX_SEEDED_EXTENSIONS
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_seeded_extensions
PROMPT
--
EXEC DropTable ('XXMX_SEEDED_EXTENSIONS')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_seeded_extensions
PROMPT
--
CREATE TABLE xxmx_core.xxmx_seeded_extensions
                  (
                   application_suite               VARCHAR2(5)      NOT NULL   
                  ,application                     VARCHAR2(5)      NOT NULL   
                  ,business_entity                 VARCHAR2(30)     NOT NULL   
                  ,phase                           VARCHAR2(20)     NOT NULL   
                  ,schema_name                     VARCHAR2(128)    NOT NULL   
                  ,extension_package               VARCHAR2(30)     NOT NULL   
                  ,extension_procedure             VARCHAR2(30)     NOT NULL
                  ,order_to_sub_extensions         VARCHAR2(6)      NOT NULL   
                  ,execution_sequence              NUMBER(2)        NOT NULL
                  ,execute_next_on_error           VARCHAR2(1)                 
                  ,enabled_flag                    VARCHAR2(1)                 
                  ,comments                        VARCHAR2(2000)              
                  ,creation_date                   DATE
                  ,created_by                      VARCHAR2(240)
                  ,last_update_date                DATE
                  ,last_updated_by                 VARCHAR2(240)
                  );
--
PROMPT
PROMPT Creating Index xxmx_seeded_extensions_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_seeded_extensions_u1
                 ON xxmx_core.xxmx_seeded_extensions
                         (
                          application_suite
                         ,application
                         ,business_entity
                         ,phase
                         ,execution_sequence
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_seeded_extensions_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_seeded_extensions_u2
                 ON xxmx_core.xxmx_seeded_extensions
                         (
                          schema_name
                         ,extension_package
                         ,extension_procedure
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
/*
** XXMX_SEEDED_SUB_EXTENSIONS
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_seeded_sub_extensions
PROMPT
--
EXEC DropTable ('XXMX_SEEDED_SUB_EXTENSIONS')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_seeded_sub_extensions
PROMPT
--
CREATE TABLE xxmx_core.xxmx_seeded_sub_extensions
                  (
                   application_suite               VARCHAR2(5)      NOT NULL   
                  ,application                     VARCHAR2(5)      NOT NULL   
                  ,business_entity                 VARCHAR2(30)     NOT NULL   
                  ,sub_entity                      VARCHAR2(60)     NOT NULL   
                  ,phase                           VARCHAR2(20)     NOT NULL   
                  ,schema_name                     VARCHAR2(128)    NOT NULL   
                  ,extension_package               VARCHAR2(30)     NOT NULL   
                  ,extension_procedure             VARCHAR2(30)     NOT NULL
                  ,execution_sequence              NUMBER(2)        NOT NULL
                  ,execute_next_on_error           VARCHAR2(1)                 
                  ,enabled_flag                    VARCHAR2(1)                 
                  ,comments                        VARCHAR2(2000)              
                  ,creation_date                   DATE
                  ,created_by                      VARCHAR2(240)
                  ,last_update_date                DATE
                  ,last_updated_by                 VARCHAR2(240)
                  );
--
PROMPT
PROMPT Creating Index xxmx_seeded_sub_extensions_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_seeded_sub_extensions_u1
                 ON xxmx_core.xxmx_seeded_sub_extensions
                         (
                          application_suite
                         ,application
                         ,business_entity
                         ,sub_entity
                         ,phase
                         ,execution_sequence
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_seeded_sub_extensions_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_seeded_sub_extensions_u2
                 ON xxmx_core.xxmx_seeded_sub_extensions
                         (
                          schema_name
                         ,extension_package
                         ,extension_procedure
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
/*
** XXMX_CUSTOM_EXTENSIONS
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_custom_extensions
PROMPT
--
EXEC DropTable ('XXMX_CUSTOM_EXTENSIONS')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_custom_extensions
PROMPT
--
CREATE TABLE xxmx_core.xxmx_custom_extensions
                  (
                   application_suite               VARCHAR2(5)      NOT NULL   
                  ,application                     VARCHAR2(5)      NOT NULL   
                  ,business_entity                 VARCHAR2(30)     NOT NULL   
                  ,phase                           VARCHAR2(20)     NOT NULL   
                  ,extension_source                VARCHAR2(20)     NOT NULL   
                  ,schema_name                     VARCHAR2(128)    NOT NULL   
                  ,extension_package               VARCHAR2(30)     NOT NULL   
                  ,extension_procedure             VARCHAR2(30)     NOT NULL
                  ,order_to_sub_extensions         VARCHAR2(10)     NOT NULL   
                  ,execution_sequence              NUMBER(2)        NOT NULL
                  ,execute_next_on_error           VARCHAR2(1)                 
                  ,enabled_flag                    VARCHAR2(1)                 
                  ,comments                        VARCHAR2(2000)              
                  ,creation_date                   DATE
                  ,created_by                      VARCHAR2(240)
                  ,last_update_date                DATE
                  ,last_updated_by                 VARCHAR2(240)
                  );
--
PROMPT
PROMPT Creating Index xxmx_custom_extensions_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_custom_extensions_u1
                 ON xxmx_core.xxmx_custom_extensions
                         (
                          application_suite
                         ,application
                         ,business_entity
                         ,phase
                         ,extension_package
                         ,execution_sequence
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_custom_extensions_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_custom_extensions_u2
                 ON xxmx_core.xxmx_custom_extensions
                         (
                          schema_name
                         ,business_entity
                         ,extension_package
                         ,extension_procedure
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
/*
** XXMX_CUSTOM_SUB_EXTENSIONS
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_custom_sub_extensions
PROMPT
--
EXEC DropTable ('XXMX_CUSTOM_SUB_EXTENSIONS')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_custom_sub_extensions
PROMPT
--
CREATE TABLE xxmx_core.xxmx_custom_sub_extensions
                  (
                   application_suite               VARCHAR2(5)      NOT NULL   
                  ,application                     VARCHAR2(5)      NOT NULL   
                  ,business_entity                 VARCHAR2(30)     NOT NULL   
                  ,sub_entity                      VARCHAR2(60)     NOT NULL
                  ,phase                           VARCHAR2(20)     NOT NULL   
                  ,extension_source                VARCHAR2(20)     NOT NULL   
                  ,schema_name                     VARCHAR2(128)    NOT NULL   
                  ,extension_package               VARCHAR2(30)     NOT NULL   
                  ,extension_procedure             VARCHAR2(30)     NOT NULL
                  ,execution_sequence              NUMBER(2)        NOT NULL
                  ,execute_next_on_error           VARCHAR2(1)                 
                  ,enabled_flag                    VARCHAR2(1)                 
                  ,comments                        VARCHAR2(2000)              
                  ,creation_date                   DATE
                  ,created_by                      VARCHAR2(240)
                  ,last_update_date                DATE
                  ,last_updated_by                 VARCHAR2(240)
                  );
--
PROMPT
PROMPT Creating Index xxmx_custom_sub_extensions_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_custom_sub_extensions_u1
                 ON xxmx_core.xxmx_custom_sub_extensions
                         (
                          application_suite
                         ,application
                         ,business_entity
                         ,sub_entity
                         ,phase
                         ,execution_sequence
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
PROMPT
PROMPT Creating Index xxmx_custom_sub_extensions_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_custom_sub_extensions_u2
                 ON xxmx_core.xxmx_custom_sub_extensions
                         (
                          schema_name
                         ,extension_package
                         ,extension_procedure
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
--
--
/*
** XXMX_DATA_FILE_PROPERTIES
**
** "xfm_data_key_column" and "xfm_data_key_value" allow multiple
** Data Files to be associated with the same table but the data
** is extracted from the XFM table by specific Data Key Column and
** Value within it.
**
** "file_group_number" will be required for Finance Data Files but
** may not be required for HCM Data files (or perhaps this could be
mandatory 
** and defaulted to 1 for HCM in case they do need to use it).
*/
--
PROMPT
PROMPT Dropping Table xxmx_core.xxmx_data_file_properties
PROMPT
--
EXEC DropTable ('XXMX_DATA_FILE_PROPERTIES')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_data_file_properties
PROMPT
--
CREATE TABLE xxmx_core.xxmx_data_file_properties
                  (
                   xfm_table_id                    NUMBER           NOT NULL
                  ,xfm_data_key_column             VARCHAR2(128)
                  ,xfm_data_key_value              VARCHAR2(2000)
                  ,generation_sequence             NUMBER           NOT NULL
                  ,file_group_number               NUMBER(3)                   
                  ,data_file_name                  VARCHAR2(1000)   NOT NULL
                  ,data_file_extension             VARCHAR2(3)      NOT NULL
                  ,enabled_flag                    VARCHAR2(1)
                  );
--
PROMPT
PROMPT Creating Index xxmx_data_file_properties_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_data_file_properties_u1
                 ON xxmx_core.xxmx_data_file_properties
                         (
                          xfm_table_id
                         ,generation_sequence
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
PROMPT
PROMPT Creating Index xxmx_data_file_properties_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_data_file_properties_u2
                 ON xxmx_core.xxmx_data_file_properties
                         (
                          xfm_table_id
                         ,data_file_name
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
PROMPT
PROMPT Creating Index xxmx_data_file_properties_u3
PROMPT
--
CREATE UNIQUE INDEX xxmx_data_file_properties_u3
                 ON xxmx_core.xxmx_data_file_properties
                         (
                          xfm_table_id
                         ,generation_sequence
                         ,data_file_name
                         )
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE
     (
      INITIAL     128K
      NEXT        128K
      MINEXTENTS  1
      MAXEXTENTS  505
      PCTINCREASE 0
     );
--
--
/*
*XXMX_CUSTOMER_SCOPE_TEMP_STG
*/
--
EXEC DropTable ('XXMX_CUSTOMER_EXCLUSIONS')

--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_customer_exclusions
PROMPT
--
Create table xxmx_core.xxmx_customer_exclusions
( 
CUST_ACCOUNT_ID         NUMBER(15) ,   
ACCOUNT_NUMBER          VARCHAR2(30),  
CUST_ACCT_SITE_ID       NUMBER(15)   , 
PARTY_ID                NUMBER(15)    ,
PARTY_SITE_ID           NUMBER(15)    ,
LOCATION_ID             NUMBER(15)    ,
ORG_ID                  NUMBER(15)    ,
PARTY_SITE_NUM          VARCHAR2(100) 
);


EXEC DropTable ('XXMX_HCM_DATAFILE_XFM_MAP')

--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_hcm_datafile_xfm_map
PROMPT
--
CREATE TABLE xxmx_core.xxmx_hcm_datafile_xfm_map
(
DATAFILE_ID                 NUMBER        ,
APPLICATION_SUITE           VARCHAR2(5)   ,
APPLICATION                 VARCHAR2(5)   ,
BUSINESS_ENTITY             VARCHAR2(100) ,
SUB_ENTITY                  VARCHAR2(100) ,
DATA_FILE_NAME              VARCHAR2(100) ,
FUSION_DATA_FILE_NAME       VARCHAR2(100) ,
ENABLED_FLAG                VARCHAR2(5)   ,   
ACTION_CODE                 VARCHAR2(20)  ,
STG_TABLE					VARCHAR2(255) ,
XFM_TABLE					VARCHAR2(255) 	 
);

-- directory for NON EBS Clients
                  
CREATE OR REPLACE DIRECTORY SOURCE_DATAFILE as '/tmp/Sourcefiles';      
                  
--

EXEC DropTable ('XXMX_DM_DASHBOARD_CNTL')

CREATE TABLE xxmx_dm_dashboard_cntl (
ID                         NUMBER    ,
INSTANCE_ID                VARCHAR2(250) ,
ITERATION                  VARCHAR2(10)  ,
OIC_USER_NAME              VARCHAR2(250) ,
APPLICATION_SUITE          VARCHAR2(50)  ,
APPLICATION                VARCHAR2(50)  ,
BUSINESS_ENTITY            VARCHAR2(250) ,
SUB_ENTITY                 VARCHAR2(250) ,
MIGRATION_SET_ID           NUMBER        ,
EXTRACT_COUNT              NUMBER        ,
TRANSFORM_COUNT            NUMBER        ,
LOAD_COUNT                 NUMBER        ,
FUSION_ERROR_COUNT         NUMBER        ,
CREATED_BY                 VARCHAR2(250) ,
CREATION_DATE              DATE          ,
LAST_UPDATED_BY            VARCHAR2(250) ,
LAST_UPDATED_DATE          DATE          ,
LAST_UPDATED_LOGIN         VARCHAR2(250) ,
REQUEST_ID                 NUMBER        ,
IMPORT_SUCCESS_COUNT       NUMBER        ,
PROCESSED_FLAG             VARCHAR2(3)   ,
EXTRACT_START_TIME         VARCHAR2(30)  ,
EXTRACT_END_TIME           VARCHAR2(30)  ,
TRANSFORM_START_TIME       VARCHAR2(50)  ,
TRANSFORM_END_TIME         VARCHAR2(50)  ,
IMPORT_START_TIME          VARCHAR2(50)  ,
IMPORT_END_TIME            VARCHAR2(50)  ,
EXTRACT_STATUS             VARCHAR2(10)  ,
TRANSFORM_STATUS           VARCHAR2(10)  ,
LOAD_GEN_STATUS            VARCHAR2(10)  ,
IMPORT_STATUS              VARCHAR2(10)
);

--
--
PROMPT
PROMPT Dropping Sequence XXMX_DASHBOARD_CNTL_IDS_S
PROMPT
--
EXEC DropSequence ('XXMX_DASHBOARD_CNTL_IDS_S')
--
--
PROMPT
PROMPT Creating Sequence XXMX_DASHBOARD_CNTL_IDS_S
PROMPT
--

CREATE SEQUENCE "XXMX_CORE"."XXMX_DASHBOARD_CNTL_IDS_S" MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1
NOCACHE NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL;



EXEC DropTable ('XXMX_DM_DASHBOARD_IMPORT_REQID')

CREATE TABLE XXMX_DM_DASHBOARD_IMPORT_REQID(
	REQUEST_ID              VARCHAR2(20),  
	BUSINESS_ENTITY         VARCHAR2(100), 
	SUB_ENTITY              VARCHAR2(100), 
	APPLICATION_SUITE       VARCHAR2(10) , 
	ERROR_COUNT             NUMBER,        
	SUCCESS_COUNT           NUMBER,        
	PROCESSED_FLAG          VARCHAR2(5),
	ITERATION               VARCHAR2(50)  
);

--
--
PROMPT
PROMPT Dropping Sequence XXMX_LOADFILE_BATCHID_S
PROMPT
--
EXEC DropSequence('XXMX_LOADFILE_BATCHID_S')
--
--
--
PROMPT
PROMPT Creating Sequence XXMX_LOADFILE_BATCHID_S
PROMPT
--
CREATE SEQUENCE  "XXMX_CORE"."XXMX_LOADFILE_BATCHID_S"  
MINVALUE 1 
MAXVALUE 9999999999999999999999999999 
INCREMENT BY 1
START WITH 1 
NOCACHE 
NOORDER 
NOCYCLE 
NOKEEP  
NOSCALE  
GLOBAL ;


EXEC DropTable('XXMX_DM_FILE_BATCH')
CREATE TABLE xxmx_dm_file_batch
(TABLENAME           VARCHAR2(200) ,
BATCH_NAME          VARCHAR2(200) ,
BATCH_COLUMN        VARCHAR2(200) ,
SEQUENCEBATCH       NUMBER );
--
--
--
--
PROMPT
PROMPT Dropping Sequence XXMX_LOADFILE_STATUS_LOG_IDS_S
PROMPT
--
EXEC DropSequence('XXMX_LOADFILE_STATUS_LOG_IDS_S')
--
--
--
PROMPT
PROMPT Creating Sequence xxmx_loadfile_status_log_ids_s
PROMPT
--
CREATE SEQUENCE xxmx_loadfile_status_log_ids_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
NOORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;

EXEC DropTable('xxmx_loadfile_status_log')
--
PROMPT
PROMPT Creating Table xxmx_core.xxmx_loadfile_status_log
PROMPT
--
CREATE TABLE xxmx_core.xxmx_loadfile_status_log
(
load_file_id NUMBER PRIMARY KEY,
iteration  VARCHAR2(10) ,
filename VARCHAR2(200) ,
creation_date DATE,
status VARCHAR2(20),   
business_entity VARCHAR2(100),  
sub_entity VARCHAR2(100) , 
last_update_date DATE ,          
file_location VARCHAR2(4000),
r_instance_id VARCHAR2(200),
g_instance_id VARCHAR2(200), 
c_instance_id VARCHAR2(200)
);
--
--

EXEC DropTable('DIR_LIST')
--
PROMPT
PROMPT Creating Table xxmx_core.DIR_LIST
PROMPT
--
CREATE TABLE xxmx_core.DIR_LIST(File_name VARCHAR2(500));


EXEC DropTable('XXMX_LIST_DB_LOADFILE')
--
PROMPT
PROMPT Creating Table xxmx_core.XXMX_LIST_DB_LOADFILE
PROMPT
--
CREATE TABLE xxmx_core.XXMX_LIST_DB_LOADFILE
(
LOAD_FILE_ID VARCHAR2(10),
filename VARCHAR2(200),
business_entity VARCHAR2(100),
sub_entity VARCHAR2(100),
LAST_UPDATE_DATE DATE,
dir_path VARCHAR2(2000),
STATUS VARCHAR2(10)
);

EXEC DropTable('XXMX_CONFIGURATION_ISSUES')
--
PROMPT
PROMPT Creating Table xxmx_core.XXMX_CONFIGURATION_ISSUES
PROMPT
--
CREATE TABLE XXMX_CONFIGURATION_ISSUES
(
APPLICATION_SUITE                     VARCHAR2(50), 
APPLICATION                           VARCHAR2(50),  
BUSINESS_ENTITY                       VARCHAR2(50),  
SUB_ENTITY                            VARCHAR2(50), 
STG_TABLE_EXISTS                      VARCHAR2(500), 
XFM_TABLE_EXISTS                      VARCHAR2(500), 
STG_ARCH_EXISTS                       VARCHAR2(500), 
XFM_ARCH_EXISTS                       VARCHAR2(500), 
STG_POPULATE_EXISTS                   VARCHAR2(500), 
XFM_POPULATE_EXISTS                   VARCHAR2(500), 
METADATA_ENTRY                        VARCHAR2(500), 
COLUMN_STATUS                         VARCHAR2(500), 
FILE_LOCATION_STATUS                  VARCHAR2(500), 
DIRECTORY_STATUS                      VARCHAR2(500),
INCLUDE_IN_OUTBOUND_FILE_STATUS       VARCHAR2(500)
);


Update xxmx_migration_metadata
set FILE_GEN_PACKAGE = NULL, FILE_GEN_PROCEDURE_NAME = NULL;

--
--PROMPT
--PROMPT
--PROMPT *****************
--PROMPT ** Creating Views
--PROMPT *****************
----
----
--PROMPT
--PROMPT Creating View [view_name] in the [schema_name] Schema
--PROMPT
----
--CREATE OR REPLACE VIEW [view_name]
--AS
--SELECT  [column_list]
--FROM    [table_list]
--WHERE   [where_clauses];
--
--
--PROMPT
--PROMPT
--PROMPT ***********************
--PROMPT ** Granting Permissions
--PROMPT ***********************
----
----
--PROMPT
--PROMPT Granting permissions
--PROMPT
----
--GRANT ALL ON xxmx_migration_parameters TO xxmx_???;
----
----
--PROMPT
--PROMPT
--PROMPT ****************************
--PROMPT ** Creating Private Synonyms
--PROMPT ****************************
----
----
--CONNECT xxmx_???/&xxmx_???_pwd
----
----
--PROMPT
--PROMPT Dropping Private Synonyms
--PROMPT
----
--DROP SYNONYM xxmx_migration_parameters;
----
----
--PROMPT
--PROMPT Creating Private Synonyms
--PROMPT
----
--CREATE SYNONYM xxmx_migration_parameters
--           FOR xxmx_stg.xxmx_migration_parameters;
----
----
--
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
PROMPT
--
--
