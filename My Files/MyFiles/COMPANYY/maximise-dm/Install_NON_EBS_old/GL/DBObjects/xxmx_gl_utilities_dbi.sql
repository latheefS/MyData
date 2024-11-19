--ALTER SESSION SET CONTAINER = MXDM_PDB1;
--
--
--CONNECT xxmx_core/&xxmx_core_pwd
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
--**   1.X  16-FEB-2021  Ian S. Vickerstaff  Removed default AP and AR Accounts
--**                                         from the XXMX_GL_SOURCE_STRUCTURES
--**                                         table as they should be associated
--**                                         with Operating Unit and so will be
--**                                         included in the new
--**                                         XXMX_SOURCE_OPERATING_UNITS table.
--**
--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT ********************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise GL Utilities
PROMPT **
PROMPT ********************************************************
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
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Dropping Tables
PROMPT ******************
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_source_structures
PROMPT
--
EXEC DropTable ('XXMX_GL_SOURCE_STRUCTURES')
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_source_struct_segments
PROMPT
--
EXEC DropTable ('XXMX_GL_SOURCE_STRUCT_SEGMENTS')
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_fusion_structures
PROMPT
--
EXEC DropTable ('XXMX_GL_FUSION_STRUCTURES')
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_fusion_struct_segments
PROMPT
--
EXEC DropTable ('XXMX_GL_FUSION_STRUCT_SEGMENTS')
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_segment_1_to_1_maps
PROMPT
--
EXEC DropTable ('XXMX_GL_SEGMENT_1_TO_1_MAPS')
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_fusion_seg_defaults
PROMPT
--
EXEC DropTable ('XXMX_GL_FUSION_SEG_DEFAULTS')
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_acct_seg_transforms
PROMPT
--
EXEC DropTable ('XXMX_GL_ACCT_SEG_TRANSFORMS')
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_account_transforms
PROMPT
--
EXEC DropTable ('XXMX_GL_ACCOUNT_TRANSFORMS')
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
PROMPT Creating Table xxmx_gl_source_structures
PROMPT
--
CREATE TABLE xxmx_gl_source_structures
                  (
                   source_ledger_name              VARCHAR2(30)    NOT NULL  
                  ,source_segment_delimiter        VARCHAR2(1)     NOT NULL  
                  ,currency_code                   VARCHAR2(15)    NOT NULL 
                  ,gl_bal_fusion_jrnl_source       VARCHAR2(25)
                  ,gl_bal_fusion_jrnl_category     VARCHAR2(25)
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_gl_source_struct_segments
PROMPT
--
CREATE TABLE xxmx_gl_source_struct_segments
                  (
                   source_ledger_name              VARCHAR2(30) NOT NULL  
                  ,source_segment_num              NUMBER(15)   NOT NULL  
                  ,source_segment_name             VARCHAR2(30) NOT NULL  
                  ,source_segment_column           VARCHAR2(30) NOT NULL  
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_gl_fusion_structures
PROMPT
--
CREATE TABLE xxmx_gl_fusion_structures
                  (
                   fusion_ledger_name              VARCHAR2(30)   NOT NULL  
                  ,fusion_segment_delimiter        VARCHAR2(1)    NOT NULL  
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_gl_fusion_struct_segments
PROMPT
--
CREATE TABLE xxmx_gl_fusion_struct_segments
                  (
                   fusion_ledger_name              VARCHAR2(30) NOT NULL  
                  ,fusion_segment_num              NUMBER(15)   NOT NULL  
                  ,fusion_segment_name             VARCHAR2(30) NOT NULL  
                  ,fusion_segment_column           VARCHAR2(30) NOT NULL  
                  ,fusion_segment_length           NUMBER       NOT NULL  
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_gl_segment_1_to_1_maps
PROMPT
--
CREATE TABLE xxmx_gl_segment_1_to_1_maps
                  (
                   source_ledger_name              VARCHAR2(30) NOT NULL  
                  ,source_segment_name             VARCHAR2(30)           
                  ,source_segment_column           VARCHAR2(30) NOT NULL 
                  ,fusion_ledger_name              VARCHAR2(30) NOT NULL  
                  ,fusion_segment_name             VARCHAR2(30)           
                  ,fusion_segment_column           VARCHAR2(30) NOT NULL
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_gl_fusion_seg_defaults
PROMPT
--
CREATE TABLE xxmx_gl_fusion_seg_defaults
                  (
                   fusion_ledger_name              VARCHAR2(30) NOT NULL  
                  ,fusion_segment_column           VARCHAR2(30) NOT NULL  
                  ,fusion_segment_default_value    VARCHAR2(25) NOT NULL  
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_gl_acct_seg_transforms
PROMPT
--
CREATE TABLE xxmx_gl_acct_seg_transforms
                  (
                   data_source                     VARCHAR2(10) NOT NULL  
                  ,source_ledger_name              VARCHAR2(30) NOT NULL  
                  ,source_segment_name             VARCHAR2(30)           
                  ,source_segment_column           VARCHAR2(30) NOT NULL  
                  ,source_segment_value            VARCHAR2(25) NOT NULL  
                  ,source_segment_value_enabled    VARCHAR2(1)            
                  ,fusion_segment_value            VARCHAR2(25)           
                  ,frozen_flag                     VARCHAR2(1)  NOT NULL 
                  );
--
--
PROMPT
PROMPT Creating Table xxmx_gl_account_transforms
PROMPT
--
CREATE TABLE xxmx_gl_account_transforms
                  (
                   application_suite               VARCHAR2(5)     NOT NULL
                  ,application                     VARCHAR2(5)     NOT NULL
                  ,business_entity                 VARCHAR2(100)   NOT NULL
                  ,sub_entity                      VARCHAR2(100)   NOT NULL
                  ,source_ledger_name              VARCHAR2(30)    NOT NULL
                  ,source_account_type             VARCHAR2(1)
                  ,source_account_type_meaning     VARCHAR2(80)
                  ,source_account_enabled_flag     VARCHAR2(1)
                  ,source_concatenated_segments    VARCHAR2(1000)
                  ,source_segment1                 VARCHAR2(25)
                  ,source_segment2                 VARCHAR2(25)
                  ,source_segment3                 VARCHAR2(25)
                  ,source_segment4                 VARCHAR2(25)
                  ,source_segment5                 VARCHAR2(25)
                  ,source_segment6                 VARCHAR2(25)
                  ,source_segment7                 VARCHAR2(25)
                  ,source_segment8                 VARCHAR2(25)
                  ,source_segment9                 VARCHAR2(25)
                  ,source_segment10                VARCHAR2(25)
                  ,source_segment11                VARCHAR2(25)
                  ,source_segment12                VARCHAR2(25)
                  ,source_segment13                VARCHAR2(25)
                  ,source_segment14                VARCHAR2(25)
                  ,source_segment15                VARCHAR2(25)
                  ,source_segment16                VARCHAR2(25)
                  ,source_segment17                VARCHAR2(25)
                  ,source_segment18                VARCHAR2(25)
                  ,source_segment19                VARCHAR2(25)
                  ,source_segment20                VARCHAR2(25)
                  ,source_segment21                VARCHAR2(25)
                  ,source_segment22                VARCHAR2(25)
                  ,source_segment23                VARCHAR2(25)
                  ,source_segment24                VARCHAR2(25)
                  ,source_segment25                VARCHAR2(25)
                  ,source_segment26                VARCHAR2(25)
                  ,source_segment27                VARCHAR2(25)
                  ,source_segment28                VARCHAR2(25)
                  ,source_segment29                VARCHAR2(25)
                  ,source_segment30                VARCHAR2(25)
                  ,fusion_ledger_name              VARCHAR2(30)
                  ,fusion_concatenated_segments    VARCHAR2(1000)
                  ,fusion_segment1                 VARCHAR2(25)
                  ,fusion_segment2                 VARCHAR2(25)
                  ,fusion_segment3                 VARCHAR2(25)
                  ,fusion_segment4                 VARCHAR2(25)
                  ,fusion_segment5                 VARCHAR2(25)
                  ,fusion_segment6                 VARCHAR2(25)
                  ,fusion_segment7                 VARCHAR2(25)
                  ,fusion_segment8                 VARCHAR2(25)
                  ,fusion_segment9                 VARCHAR2(25)
                  ,fusion_segment10                VARCHAR2(25)
                  ,fusion_segment11                VARCHAR2(25)
                  ,fusion_segment12                VARCHAR2(25)
                  ,fusion_segment13                VARCHAR2(25)
                  ,fusion_segment14                VARCHAR2(25)
                  ,fusion_segment15                VARCHAR2(25)
                  ,fusion_segment16                VARCHAR2(25)
                  ,fusion_segment17                VARCHAR2(25)
                  ,fusion_segment18                VARCHAR2(25)
                  ,fusion_segment19                VARCHAR2(25)
                  ,fusion_segment20                VARCHAR2(25)
                  ,fusion_segment21                VARCHAR2(25)
                  ,fusion_segment22                VARCHAR2(25)
                  ,fusion_segment23                VARCHAR2(25)
                  ,fusion_segment24                VARCHAR2(25)
                  ,fusion_segment25                VARCHAR2(25)
                  ,fusion_segment26                VARCHAR2(25)
                  ,fusion_segment27                VARCHAR2(25)
                  ,fusion_segment28                VARCHAR2(25)
                  ,fusion_segment29                VARCHAR2(25)
                  ,fusion_segment30                VARCHAR2(25)
                  ,segments_not_transformed        VARCHAR2(1000)
                  ,frozen_flag                     VARCHAR2(1)
                  );
--
--
--
PROMPT
PROMPT
PROMPT *******************
PROMPT ** Creating Indexes
PROMPT *******************
--
--
/*
** Indexes on table xxmx_gl_source_structures
*/
--
PROMPT
PROMPT Creating Index xxmx_gl_source_structures_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_gl_source_structures_u1
                 ON xxmx_gl_source_structures
                         (
                          source_ledger_name
                         )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
      MINEXTENTS  1 
      MAXEXTENTS  505 
      PCTINCREASE 0 
     );
--
--
/*
** Indexes on table xxmx_gl_source_struct_segments
*/
--
PROMPT
PROMPT Creating Index xxmx_gl_source_struct_segs_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_gl_source_struct_segs_u1
                 ON xxmx_gl_source_struct_segments
                         (
                          source_ledger_name
                         ,source_segment_num
                         )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
      MINEXTENTS  1 
      MAXEXTENTS  505 
      PCTINCREASE 0 
     );
--
--
PROMPT
PROMPT Creating Index xxmx_gl_source_struct_segs_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_gl_source_struct_segs_u2
                 ON xxmx_gl_source_struct_segments
                         (
                          source_ledger_name
                         ,source_segment_column
                         )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
      MINEXTENTS  1 
      MAXEXTENTS  505 
      PCTINCREASE 0 
     );
--
--
/*
** Indexes on table xxmx_gl_fusion_structures
*/
--
PROMPT
PROMPT Creating Index xxmx_gl_fusion_structures_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_gl_fusion_structures_u1
                 ON xxmx_gl_fusion_structures
                         (
                          fusion_ledger_name
                         )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
      MINEXTENTS  1 
      MAXEXTENTS  505 
      PCTINCREASE 0 
     );
--
--
/*
** Indexes on table xxmx_gl_fusion_struct_segments
*/
--
PROMPT
PROMPT Creating Index xxmx_gl_fusion_struct_segs_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_gl_fusion_struct_segs_u1
                 ON xxmx_gl_fusion_struct_segments
                         (
                          fusion_ledger_name
                         ,fusion_segment_num
                         )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
      MINEXTENTS  1 
      MAXEXTENTS  505 
      PCTINCREASE 0 
     );
--
--
PROMPT
PROMPT Creating Index xxmx_gl_fusion_struct_segs_u2
PROMPT
--
CREATE UNIQUE INDEX xxmx_gl_fusion_struct_segs_u2
                 ON xxmx_gl_fusion_struct_segments
                         (
                          fusion_ledger_name
                         ,fusion_segment_column
                         )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
      MINEXTENTS  1 
      MAXEXTENTS  505 
      PCTINCREASE 0 
     );
--
--
/*
** Indexes on table xxmx_gl_segment_1_to_1_maps
*/
--
PROMPT
PROMPT Creating Index xxmx_gl_fusion_seg_defaults_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_gl_segment_1_to_1_maps_u1
                 ON xxmx_gl_segment_1_to_1_maps
                         (
                          source_ledger_name
                         ,source_segment_column
                         )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
      MINEXTENTS  1 
      MAXEXTENTS  505 
      PCTINCREASE 0 
     );
--
--
PROMPT
PROMPT Creating Index xxmx_gl_fusion_seg_defaults_n1
PROMPT
--
CREATE INDEX xxmx_gl_segment_1_to_1_maps_n1
          ON xxmx_gl_segment_1_to_1_maps
                  (
                   source_ledger_name
                  ,fusion_ledger_name
                  )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
      MINEXTENTS  1 
      MAXEXTENTS  505 
      PCTINCREASE 0 
     );
--
--
/*
** Indexes on table xxmx_gl_fusion_seg_defaults
*/
--
PROMPT
PROMPT Creating Index xxmx_gl_fusion_seg_defaults_u1
PROMPT
--
CREATE UNIQUE INDEX xxmx_gl_fusion_seg_defaults_u1
                 ON xxmx_gl_fusion_seg_defaults
                         (
                          fusion_ledger_name
                         ,fusion_segment_column
                         )
PCTFREE    10 
INITRANS   2 
MAXTRANS   255 
STORAGE
     (
      INITIAL     64K 
      NEXT        64K
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
--GRANT ALL ON xxmx_migration_parameters TO xxmx_xfm;
----
----
--GRANT ALL ON xxmx_migration_headers TO xxmx_xfm;
----
----
--GRANT ALL ON xxmx_migration_details TO xxmx_xfm;
----
----
--GRANT ALL ON xxmx_simple_transforms TO xxmx_xfm;
----
----
--GRANT ALL ON xxmx_migration_parameter_ids_s TO xxmx_xfm;
----
----
--GRANT ALL ON xxmx_migration_set_ids_s TO xxmx_xfm;
----
----
--GRANT ALL ON xxmx_simple_transforms_ids_s TO xxmx_xfm;
----
----
----
--PROMPT
--PROMPT
--PROMPT ****************************
--PROMPT ** Creating Private Synonyms
--PROMPT ****************************
----
----
--CONNECT xxdm_xfm/&xxmx_xfm_pwd
----
----
--PROMPT
--PROMPT Dropping Private Synonyms
--PROMPT
----
--DROP SYNONYM xxmx_migration_parameters;
----
----
--DROP SYNONYM xxmx_migration_headers;
----
----
--DROP SYNONYM xxmx_migration_details;
----
----
--DROP SYNONYM xxmx_simple_transforms;
----
----
--DROP SYNONYM xxmx_migration_parameter_ids_s;
----
----
--DROP SYNONYM xxmx_migration_set_ids_s;
----
----
--DROP SYNONYM xxmx_simple_transforms_ids_s;
----
----
--PROMPT
--PROMPT Creating Private Synonyms
--PROMPT
----
--CREATE SYNONYM xxmx_migration_parameters
--           FOR  xxmx_migration_parameters;
----
----
--CREATE SYNONYM xxmx_migration_headers
--           FOR  xxmx_migration_headers;
----
----
--CREATE SYNONYM xxmx_fin_migration_details
--           FOR  xxmx_migration_details;
----
----
--CREATE SYNONYM xxmx_simple_transforms
--           FOR  xxmx_simple_transforms;
----
----
--CREATE SYNONYM xxmx_migration_parameter_ids_s
--           FOR  xxmx_migration_parameter_ids_s;
----
----
--CREATE SYNONYM xxmx_migration_set_ids_s
--           FOR  xxmx_migration_set_ids_s;
----
----
--CREATE SYNONYM xxmx_simple_transforms_ids_s
--           FOR  xxmx_simple_transforms_ids_s;
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
