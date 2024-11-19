--------------------------------------------------------
--  DDL for Package Body XXMX_REQUEST_SCHEDULING_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_REQUEST_SCHEDULING_PKG" 
IS
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                           CONSTANT VARCHAR2(30) := 'xxmx_request_scheduling_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := '';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := '';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT  VARCHAR2(10)                                := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT  VARCHAR2(10)                                := 'xxmx_core';
     gcv_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := '';
     --
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     /* Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     /* Global constants and variables for dynamic SQL usage */
     --
     gcv_SQLSpace                             CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                                      VARCHAR2(20);
     gvv_SQLTableClause                                 VARCHAR2(100);
     gvv_SQLColumnList                                  VARCHAR2(4000);
     gvv_SQLValuesList                                  VARCHAR2(4000);
     gvv_SQLWhereClause                                 VARCHAR2(4000);
     gvv_SQLStatement                                   VARCHAR2(32000);
     gvv_SQLResult                                      VARCHAR2(4000);
     --
     /* Global variables for holding table row counts */
     --
     gvn_RowCount                                       NUMBER;
     --
     --
     --
	 -- ----------------------------------------------------------------------------
	 -- |----------------------< schedule_gl_balances_xfm >------------------------|
	 -- ----------------------------------------------------------------------------


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
                                        pt_o_JobName               OUT     sys.all_scheduler_jobs.job_name%TYPE) IS
     --
     vt_msg        VARCHAR2(1000);
     vt_code       VARCHAR2(1000);
     vt_procname   VARCHAR2(100) := 'LOAD_GL_BAL';
     vt_jobname    VARCHAR2(128) := 'load_gl_bal'||to_char(sysdate,'DDMMYYYYHH24MISS');
	 vi_request_id NUMBER;
     --
     BEGIN
     --
     -- Insert current request details - using ALL_SCHEDULER_JOBS table so now redundant
     --
/*
	 select xxmx_scheduled_request_id_s.nextval into vi_request_id from dual;

     insert into XXMX_SCHEDULED_REQUESTS(request_id,
	                                     migration_set_id,
                                         procedure_name,
		  					             start_time,
			   				             end_time,
				  			             request_status)
     values (vi_request_id, pt_i_MigrationSetID, vt_procname, sysdate, null, 'S');
*/

--     vt_code := 'BEGIN xxmx_gl_balances_pkg.call_gl_balances_xfm('''||pt_i_MigrationSetID||''','''||pt_i_SubEntity||''','''||pt_i_SimpleXfmPerformedBy||'''); END;';
     vt_code := 'BEGIN xxmx_gl_balances_pkg.gl_balances_xfm('''||pt_i_MigrationSetID||''','''||pt_i_SubEntity||''','''||pt_i_SimpleXfmPerformedBy||'''); END;';

     dbms_scheduler.create_job (
--        job_name   =>  'load_gl_bal'||to_char(sysdate,'DDMMYYYYHH24MISS'),
        job_name   =>  vt_jobname,
        job_type   =>  'PLSQL_BLOCK',
        job_action =>  vt_code,
        enabled    =>  TRUE,
        auto_drop  =>  TRUE,
        comments   =>  'Load gl data');

     pt_o_JobName := UPPER(vt_jobname);
     EXCEPTION
     --
     WHEN OTHERS THEN
        vt_msg := SQLERRM;
        -- Return error
        update XXMX_SCHEDULED_REQUESTS
        set    end_time         = sysdate,
               REQUEST_STATUS   = 'E',
               comments         = vt_msg
        where  request_id       = vi_request_id
		and    migration_set_id = pt_i_MigrationSetID
	    and    procedure_name   = vt_procname;
     END;
     --
     --
	 PROCEDURE get_scheduled_job_status(pt_i_Owner                 IN      sys.ALL_SCHEDULER_JOB_RUN_DETAILS.owner%TYPE,
                                        pt_i_JobName               IN      sys.ALL_SCHEDULER_JOB_RUN_DETAILS.job_name%TYPE,
                                        pt_o_JobStatus             OUT     sys.ALL_SCHEDULER_JOB_RUN_DETAILS.status%TYPE) IS
          /*
          **********************
          ** CURSOR Declarations
          **********************
          */
          --
          -- Cursor to get the pre-transform data
          --
          CURSOR JobStatus_cur
                      (
                       pt_Owner     sys.ALL_SCHEDULER_JOB_RUN_DETAILS.owner%TYPE,
                       pt_JobName   sys.ALL_SCHEDULER_JOB_RUN_DETAILS.job_name%TYPE
                      )
          IS
             SELECT status
             FROM   all_scheduler_job_run_details
             WHERE  owner    = pt_owner
             AND    job_name = pt_JobName
             UNION
             SELECT 'RUNNING'
             FROM  all_scheduler_jobs
             WHERE owner     = pt_owner
             AND    job_name =  pt_JobName;
     --
     --
     vt_jobstatus    sys.ALL_SCHEDULER_JOB_RUN_DETAILS.status%TYPE;
     --
     --
     BEGIN
        OPEN JobStatus_cur(pt_i_Owner, pt_i_JobName);
        FETCH JobStatus_cur into vt_jobstatus;
        --
        IF JobStatus_cur%NOTFOUND THEN
           vt_jobstatus := 'NOTFOUND';
        END IF;
        --
        CLOSE JobStatus_cur;

        pt_o_JobStatus := vt_jobstatus;
     EXCEPTION
     --
     WHEN OTHERS THEN
        pt_o_JobStatus := 'ERROR';
     END get_scheduled_job_status;
     --
     --
END XXMX_REQUEST_SCHEDULING_PKG;

/
