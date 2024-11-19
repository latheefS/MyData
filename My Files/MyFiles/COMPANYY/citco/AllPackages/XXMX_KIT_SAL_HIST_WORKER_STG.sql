--------------------------------------------------------
--  DDL for Package XXMX_KIT_SAL_HIST_WORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_SAL_HIST_WORKER_STG" AS
--*****************************************************************************
--**
--** FILENAME  :  xxmx_kit_ppm_worker_stg.sql
--**
--** PURPOSE   :  This script Generates Worker Hire and Worker Assignment History HDL file
--**              for Salary Workers List.

procedure update_salary_assignment_hist;

procedure generate_worker_hire_hdl;

procedure generate_worker_gltransfer_hdl;

procedure generate_salary_assignment_hist_hdl;

procedure generate_salary_termination_hdl;

procedure generate_salary_rehire_hdl;

procedure generate_salary_rehire_glbtrans_hdl;

procedure generate_salary_rehire_asg_hist_hdl;

procedure main;

end xxmx_kit_sal_hist_worker_stg;

/
