--------------------------------------------------------
--  DDL for Package XXMX_REQUEST_SCHEDULING_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_REQUEST_SCHEDULING_PKG" 
IS
     --
     --
     /*
     ********************************************
     ** GLOBAL TYPES ACCESSIBLE BY OTHER PACKAGES
     ********************************************
     */
     --
     --
     /*
     ************************************************
     ** GLOBAL CONSTANTS ACCESSIBLE BY OTHER PACKAGES
     ************************************************
     */
     --
     --
     /*
     ************************************************
     ** GLOBAL VARIABLES ACCESSIBLE BY OTHER PACKAGES
     ************************************************
     */
     --
     --
     /*
     **************************************
     ** PROCEDURE AND FUNCTION DECLARATIONS
     **************************************
     */
     --
	 /*
     ********************************************
     ** PROCEDURE: schedule_gl_balances_xfm
     **
     ** Called from OIC flow to submit the PL/SQL
	 ** transform procedure.
     ********************************************
     */
     --
	 PROCEDURE schedule_gl_balances_xfm(pt_i_MigrationSetID        IN      xxmx_migration_headers.migration_set_id%TYPE,
                                        pt_i_SubEntity             IN      xxmx_migration_metadata.sub_entity%TYPE,
                                        pt_i_SimpleXfmPerformedBy  IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE,
                                        pt_o_JobName               OUT     sys.all_scheduler_jobs.job_name%TYPE);
     --
	 PROCEDURE get_scheduled_job_status(pt_i_Owner                 IN      sys.ALL_SCHEDULER_JOB_RUN_DETAILS.owner%TYPE,
                                        pt_i_JobName               IN      sys.ALL_SCHEDULER_JOB_RUN_DETAILS.job_name%TYPE,
                                        pt_o_JobStatus             OUT     sys.ALL_SCHEDULER_JOB_RUN_DETAILS.status%TYPE);

     --
END XXMX_REQUEST_SCHEDULING_PKG;

/
