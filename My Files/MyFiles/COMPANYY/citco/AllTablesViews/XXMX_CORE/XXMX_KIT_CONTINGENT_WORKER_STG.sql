--------------------------------------------------------
--  DDL for Package XXMX_KIT_CONTINGENT_WORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_CONTINGENT_WORKER_STG" AS
--*****************************************************************************
--**
--** FILENAME  :  xxmx_kit_contingent_worker_stg.sql
--**
--** PURPOSE   :  This script Generates Worker Hire and Worker Assignment HDL file
--**              for Contingent Workers List.

procedure generate_contingent_worker_hire_hdl;

procedure generate_contingent_worker_current_hdl;

end xxmx_kit_contingent_worker_stg;

/
