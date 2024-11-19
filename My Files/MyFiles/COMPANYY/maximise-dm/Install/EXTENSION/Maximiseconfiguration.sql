--*****************************************************************************
--**
--** FILENAME  :  Maximiseconfiguration.sql
--**
--** AUTHORS   :  Pallavi
--**
--** PURPOSE   :  This script creates ext,stg and xfm table for new Business Entity
--**
--** NOTES     :
--**
--******************************************************************************

--==============================================================================

-- EXTERNAL TABLE CREATION
-- Only for Non EBS Clients
-- Number of Tables depends on how many data source file
-- columns depend on the Data Source file
--
DROP     TABLE XXMX_CORE.<External_Table_name>;

CREATE TABLE XXMX_CORE.<External_Table_name>
(
 FILE_SET_ID                  VARCHAR2(30) -- Mandatory for Maximise 
,column2            VARCHAR2(200)
,column2            VARCHAR2(200)
,column2            VARCHAR2(200)
)
ORGANIZATION EXTERNAL
(
TYPE ORACLE_LOADER
DEFAULT DIRECTORY "SOURCE_DATAFILE"
ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE SKIP 1 LOGFILE <staging_Table.log> FIELDS TERMINATED BY "," OPTIONALLY ENCLOSED BY '"' MISSING FIELD VALUES ARE NULL
    )
    LOCATION (<Staging_Table>.csv)
)
REJECT LIMIT UNLIMITED 
PARALLEL 5 ;
--
--
--=============================================================================


--=============================================================================
-- STG TABLE CREATION
-- Create Staging table for the entity
-- Table should have all the columns needed for FBDI or HDL Generation

DROP     TABLE XXMX_STG.<Staging_table_name> PURGE;

CREATE TABLE XXMX_STG.<Staging_table_name>
(
 FILE_SET_ID                 VARCHAR2(30) -- Mandatory for Maximise 
,MIGRATION_SET_ID            NUMBER       -- Mandatory for Maximise 
,MIGRATION_SET_NAME          VARCHAR2(100) -- Mandatory for Maximise 
,MIGRATION_STATUS            VARCHAR2(50) -- Mandatory for Maximise 
--All FBDI Columns should be defined
);
--==============================================================================


--==============================================================================
--
--
-- XFM TABLE CREATION
--
DROP    TABLE XXMX_XFM.<Transformation_table_name>  PURGE;
-- Create Transformation table for the entity
-- Table should have all the columns needed for FBDI or HDL Generation
-- it should a replica of staging tables

CREATE TABLE XXMX_XFM.<Transformation_table_name>
(
 FILE_SET_ID                 VARCHAR2(30) -- Mandatory for Maximise 
,MIGRATION_SET_ID            NUMBER       -- Mandatory for Maximise 
,MIGRATION_SET_NAME          VARCHAR2(100) -- Mandatory for Maximise 
,MIGRATION_STATUS            VARCHAR2(50) -- Mandatory for Maximise 
--All FBDI Columns should be defined
);
--
--============================================================================================


--============================================================================================
--GRANTS And SYNONYM
Grant all on XXMX_STG.<Staging_table_name> to XXMX_CORE;
Grant all on XXMX_XFM.<Transformation_table_name> to XXMX_CORE;

Create Synonym XXMX_CORE.<Staging_table_name> for XXMX_STG.<Staging_table_name>;
Create Synonym XXMX_CORE.<Transformation_table_name> for XXMX_XFM.<Transformation_table_name>;
--
--==============================================================================================


--==============================================================================================
-- Maximise Configuration 
SELECT BUSINESS_ENTITY_SEQ FROM XXMX_MIGRATION_METADATA ORDER BY BUSINESS_ENTITY_SEQ DESC; -- to get the next number for Metadata_tables.


SELECT * FROM XXMX_MIGRATION_METADATA ORDER BY 1 DESC;

--Populate Metadata_tables.

INSERT INTO xxmx_migration_metadata
VALUES
(XXMX_MIGRATION_METADATA_IDS_S.nextval,<application_suite>,<application>,<Maximum business_entity_seq+1>
,<business_entity>,'1',<Sub_entity>,NULL,NULL,NULL,<staging_Table_name>,NULL,NULL,<Transformation_table_name>,
null,null,null,<FBDIFilename- csvfilename>,'csv',1,'Y',NULL,NULL);
--
--
--==============================================================================================


--==============================================================================================
-- Populate Data Dictionaly tables - Mandatory for new business_entity
-- Execute it in same order first xfm_populate and then stg_populate scripts.

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=><application_suite>,
pt_i_Application=> <application>,
pt_i_BusinessEntity=> <business_entity>,
pt_i_SubEntity=> <sub_entity>,
pt_fusion_template_name=> <FBDIFilename- csvfilename>.csv, -- With extension
pt_fusion_template_sheet_name => FBDIFilename- csvfilename, -- without extension
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

--==============================================================================================


--==============================================================================================

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=><application_suite>,
pt_i_Application=> <application>,
pt_i_BusinessEntity=> <business_entity>,
pt_i_SubEntity=> <sub_entity>,
pt_import_data_file_name => <Staging_table_name>.csv,
pt_control_file_name => <Staging_table_name>.ctl,
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


--==============================================================================================

--==============================================================================================
-- populate Maximise lookups 
--

INSERT INTO xxmx_lookup_values VALUES
('XXMX','BUSINESS_ENTITIES',<business_entity>,<business_entity>,null,'Y','Y',NULL);

--==============================================================================================


--==============================================================================================
-- Only if you have complex tranformations
Select * from xxmx_custom_extensions;

INSERT INTO xxmx_custom_extensions (
    application_suite,
    application,
    business_entity,
    phase,
    extension_source,
    schema_name,
    extension_package,
    extension_procedure,
    order_to_sub_extensions,
    execution_sequence,
    execute_next_on_error,
    enabled_flag,
    comments,
    creation_date,
    created_by,
    last_update_date,
    last_updated_by
) VALUES (
    <application_suite>,
    <application>,
    <business_entity>,
    'TRANSFORM',
    'custom',
    'XXMX_CORE',
    <Custom_package_name>,
    <custom_procedure_name>,
    'BEFORE'
    ,1
    ,NULL
    ,'Y'
    ,NULL
    ,sysdate
    ,'-1'
    ,sysdate
    ,'-1');
    
--==============================================================================================    