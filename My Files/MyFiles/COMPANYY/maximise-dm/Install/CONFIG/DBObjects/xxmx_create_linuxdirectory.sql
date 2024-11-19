--==========================================================================
--== Log Header and timestamps
--==========================================================================

set verify off
set termout off
set echo on

spool &1/crtdir.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;


begin
    BEGIN
    dbms_scheduler.drop_job(        job_name => 'XXMX_FILE_PERMISSION');
    dbms_scheduler.drop_job(        job_name => 'XXMX_CREATE_LINUXDIR');
   EXCEPTION
   WHEN OTHERS THEN
	  NULL;
   END;

    dbms_scheduler.create_job(
        job_name => 'XXMX_CREATE_LINUXDIR',
        job_type => 'executable',
        job_action =>  '/usr/bin/mkdir',
        number_of_arguments => 2,
        auto_drop => false);

    dbms_scheduler.create_job(
        job_name => 'XXMX_FILE_PERMISSION',
        job_type => 'executable',
        job_action =>  '/usr/bin/chmod',
        number_of_arguments => 3,
        auto_drop => false);

end;
/

Create or replace procedure xxmx_create_linuxDirectory as
Cursor cur_dir
IS 
Select directory_path 
from all_directories a, xxmx_core.xxmx_migration_metadata b 
where a.directory_name = b.business_Entity;

begin

	FOR rec_dir in Cur_dir 
	LOOP
		 dbms_scheduler.set_job_argument_value('XXMX_CREATE_LINUXDIR', 1, '-p');
		 dbms_scheduler.set_job_argument_value('XXMX_CREATE_LINUXDIR', 2,rec_dir.directory_path);
		 dbms_scheduler.set_job_argument_value('XXMX_FILE_PERMISSION', 1, '-R');
	         dbms_scheduler.set_job_argument_value('XXMX_FILE_PERMISSION', 2, '777');
		 dbms_scheduler.set_job_argument_value('XXMX_FILE_PERMISSION', 3,SUBSTR(rec_dir.directory_path,1,INSTR(rec_dir.directory_path,'/',1,4)-1));

		 dbms_scheduler.run_job( job_name => 'XXMX_CREATE_LINUXDIR');
		 dbms_scheduler.run_job( job_name => 'XXMX_FILE_PERMISSION');
	END LOOP;
END;

/

exec xxmx_create_linuxDirectory;


spool off;

set verify on
set echo off
set termout on

exit
