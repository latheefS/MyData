--------------------------------------------------------
--  DDL for Package XXMX_KIT_PPM_WORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_PPM_WORKER_STG" AS
--*****************************************************************************
--**
--** FILENAME  :  xxmx_kit_ppm_worker_stg.sql
--**
--** PURPOSE   :  This script Generates Worker Hire and Worker Assignment History HDL file
--**              for PPM Workers List.

PROCEDURE update_ppm_worker_details;

procedure generate_ppm_worker_hire_hdl;

procedure generate_ppm_worker_glbtransfer_hdl;

procedure generate_ppm_worker_assignment_hdl;

procedure generate_ppm_worker_termination_hdl;

--procedure generate_ppm_worker_rehire_hdl;

end xxmx_kit_ppm_worker_stg;

/
