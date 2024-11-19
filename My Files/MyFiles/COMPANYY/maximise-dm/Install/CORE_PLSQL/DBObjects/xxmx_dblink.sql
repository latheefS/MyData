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
--** VERSION   :  2.0
--**
--** AUTHORS   :  Joe Lalor
--**
--** PURPOSE   :  MXDM 2.0 EBS Schema Link
--**
--** NOTES     :
--**
--******************************************************************************

prompt
prompt Please wait ...
prompt

set verify off
set termout off
set echo on

spool &3/dblink.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

alter system set GLOBAL_NAMES=false;		

   BEGIN
      EXECUTE IMMEDIATE 'DROP public database link MXDM_NVIS_EXTRACT' ;
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2011 THEN
         RAISE;
      END IF;
   END ;
   
/

create public database link MXDM_NVIS_EXTRACT connect to apps identified by &1 using '&2' ;

set echo off

SELECT DISTINCT 'EBS DB link successfully created'
  FROM dual@MXDM_NVIS_EXTRACT;
 
spool off;

set verify on
set echo off
set termout on

EXIT

