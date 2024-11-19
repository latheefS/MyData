--------------------------------------------------------
--  DDL for View XXMX_HCM_POSITION_LE_BU_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_POSITION_LE_BU_V" ("POSITION_CODE", "PERSON_ID", "LEG_CODE", "BU", "LEGAL_EMPLOYER") AS 
  select distinct p.position_code,
asg.person_id,
substr(p.position_code, 1,2) leg_code, -- legislation_code
substr(p.position_code,1,6) bu, -- business_unit
output_code_1 legal_employer
 from  XX_POSITION_MAP_TEMP p,
 xxmx_mapping_master m,
 XXMX_PER_ASSIGNMENTS_M_XFM asg
 where substr(p.position_code, 1,6) = m.output_code_2(+)
 and  p.position_code = asg.position_code
   and asg.action_code = 'CURRENT'
;
