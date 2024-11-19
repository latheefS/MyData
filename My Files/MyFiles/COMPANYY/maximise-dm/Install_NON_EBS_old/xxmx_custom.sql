--======================================
--== MXDM 2.0 Customisation
--======================================
--
set verify off
set termout off
set echo on

spool &1/custom.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

spool off;

set verify on
set echo off
set termout on

EXIT


