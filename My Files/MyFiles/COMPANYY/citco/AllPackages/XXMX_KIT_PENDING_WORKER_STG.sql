--------------------------------------------------------
--  DDL for Package XXMX_KIT_PENDING_WORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_PENDING_WORKER_STG" AS
--*****************************************************************************
--**
--** FILENAME  :  xxmx_kit_pending_worker_stg.sql
--**
--** PURPOSE   :  This script Generates Pending Worker Hire HDL file 
--**          

procedure insert_pendingworker_data  (p_bg_name                      IN      varchar2    ,
                                      p_bg_id                        in      number ,
                                      pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE    ,
                                      pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

procedure update_pendingworker_pesonnumbers;

procedure generate_pendingworker_hire_hdl;

end xxmx_kit_pending_worker_stg;

/
