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
--** FILENAME  : xxmx_request_scheduling_dbi.sql
--**
--** FILEPATH  :
--**
--** VERSION   : $Revision$
--**
--** EXECUTE
--** IN SCHEMA : XXMX_CORE
--**
--** AUTHORS   : David Higham
--**
--** PURPOSE   : This script creates the tables, indexes, sequences, grants,
--**             and synonyms to support the following:
--**
--**                  1) Cloudbridge Mapping and Transformation Process
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
PROMPT ** Installing Database Objects for Cloudbridge Core Functionality
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
EXEC DropSequence ('XXMX_SCHEDULED_REQUEST_ID_S')
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
PROMPT Dropping Table xxmx_scheduled_requests
PROMPT
--
EXEC DropTable ('XXMX_SCHEDULED_REQUESTS')
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
PROMPT Creating Table xxmx_scheduled_requests
PROMPT
--
CREATE TABLE xxmx_scheduled_requests
                  (
                   request_id                      NUMBER          NOT NULL
                  ,migration_set_id                VARCHAR2(100)   NOT NULL
				  ,procedure_name                  VARCHAR2(100)   NOT NULL
				  ,start_time                      DATE            NOT NULL
				  ,end_time                        DATE
				  ,request_status                  VARCHAR2(1)     NOT NULL
				  ,comments                        VARCHAR2(2000)
				  );
--
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
PROMPT Creating Sequence XXMX_SCHEDULED_REQUEST_ID_S
PROMPT
--
CREATE SEQUENCE xxmx_scheduled_request_id_s
START WITH   1
INCREMENT BY 1
MAXVALUE     9999999999999999999999999999
NOCACHE
ORDER
NOCYCLE
NOKEEP
NOSCALE
GLOBAL;
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
--           FOR  xxmx_migration_parameters;
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
--
GRANT create job to XXMX_CORE;
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
