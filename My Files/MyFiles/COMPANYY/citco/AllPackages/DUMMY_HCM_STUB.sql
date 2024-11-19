--------------------------------------------------------
--  DDL for Procedure DUMMY_HCM_STUB
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."DUMMY_HCM_STUB" 
is
begin
for r in (
 SELECT distinct  input_code_2 absencename, output_code_1 absence_type,output_code_2 absence_reason, input_code_3 legislation_code
          --  INTO v_absence_type,v_absence_reason
            FROM XXMX_MAPPING_MASTER m
           WHERE 1=1
			 AND CATEGORY_CODE = 'ABSENCE_TYPES'
             order by input_code_3 
             )
loop
if  r.legislation_code = 'All' then
 UPDATE xxmx_per_absence_xfm 
	       SET absencetype = r.absence_type
             , absencereason = r.absence_reason
         WHERE  ABSENCENAME = r.ABSENCENAME;
else
 UPDATE xxmx_per_absence_xfm 
	       SET absencetype = r.absence_type
             , absencereason = r.absence_reason             
         WHERE  ABSENCENAME = r.ABSENCENAME
           and legislationcode = r.legislation_code ;
end if;
end loop;
end dummy_hcm_Stub;

/
